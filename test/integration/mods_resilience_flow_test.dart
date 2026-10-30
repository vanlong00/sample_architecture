// Hermetic real-stack tests for the mods data path: REAL Dio + REAL retrofit
// datasource + REAL repository + REAL cubits/bloc/widgets. Only the HTTP
// adapter is fake. Covers resilience to bad server data, F3 paging, search
// races with real timing, 404 handling and F1 image hardening end to end.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/error/failure_mapper.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:busmod/core/widgets/mod_image.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/presentation/widgets/downloaded_tile.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/presentation/widgets/favorite_tile.dart';
import 'package:busmod/features/mods/data/datasources/mods_remote_datasource.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_state.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_state.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:busmod/features/mods/presentation/bloc/visible_page.dart';
import 'package:busmod/features/mods/presentation/pages/mod_detail_page.dart';
import 'package:busmod/features/mods/presentation/widgets/detail_gallery.dart';
import 'package:busmod/features/mods/presentation/widgets/detail_related.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_paged_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

const _api = 'api.busmod.test';
const _config = AppConfig(
  env: AppEnv.dev,
  baseUrl: 'https://$_api',
  enableLogging: false,
  appName: 'Busmod (Test)',
);

/// Programmable API: [handler] returns the JSON body (or a `(status, body)`
/// record) for a request; it may await a gate to simulate a slow response.
class _Api implements HttpClientAdapter {
  final requests = <Uri>[];
  late FutureOr<(int, Object?)> Function(Uri uri) handler;

  Iterable<Uri> hits(String path) => requests.where((u) => u.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    final (status, body) = await handler(options.uri);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _card(
  int id, {
  bool mirrored = true,
  String type = 'bus',
  String? thumb,
  List<String> images = const [],
}) => {
  'sourceId': id,
  'type': type,
  'title': 'Mod $id',
  'media': {
    'thumbnail': thumb ?? 'https://img.busmod.test/$id.png',
    'images': images,
  },
  'download': {
    'url': 'https://www.mediafire.com/file/x/$id.rar/file',
    if (mirrored) 'storageUrl': 'https://cdn.busmod.test/files/$id.rar',
    'sizeBytes': 100,
  },
};

Widget _app(Widget home) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(body: home),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Api api;
  late ModsRepositoryImpl repo;

  setUp(() {
    api = _Api();
    final dio = buildDio(_config, MemCacheStore())..httpClientAdapter = api;
    repo = ModsRepositoryImpl(ModsRemoteDataSource(dio));
  });

  int skipOf(Uri u) => int.parse(u.queryParameters['skip'] ?? '0');

  group('bad server data', () {
    test('one bad card (unknown type), a non-map item and null are skipped; '
        'the rest renders; paging uses the RAW length', () async {
      api.handler = (u) {
        final skip = skipOf(u);
        if (skip > 0) return (200, [_card(900)]);
        return (
          200,
          [
            for (var i = 1; i <= 17; i++) _card(i),
            _card(18, type: 'spaceship'), // unknown enum value
            'not a map',
            null,
          ],
        );
      };
      final cubit = ModListCubit(repo, ModType.bus);
      await cubit.load();

      final s = cubit.state as ModListSuccess;
      expect(s.items.map((c) => c.sourceId), [for (var i = 1; i <= 17; i++) i]);
      expect(s.nextSkip, 20); // raw length, not 17
      expect(s.hasMore, isTrue); // raw 20 >= pageSize

      await cubit.loadMore();
      expect(api.hits('/mods').last.queryParameters['skip'], '20');
      expect((cubit.state as ModListSuccess).items.last.sourceId, 900);
      await cubit.close();
    });

    test('a raw page of 19 with a bad card still ends paging', () async {
      api.handler = (_) =>
          (200, [for (var i = 1; i <= 18; i++) _card(i), 'junk']);
      final cubit = ModListCubit(repo, ModType.bus);
      await cubit.load();
      final s = cubit.state as ModListSuccess;
      expect(s.items, hasLength(18));
      expect(s.nextSkip, 19);
      expect(s.hasMore, isFalse);
      await cubit.close();
    });

    test('a non-array 200 body is a user-visible server error, not a '
        'crash or an empty list', () async {
      api.handler = (_) => (200, {'oops': 'object not list'});
      final cubit = ModListCubit(repo, ModType.bus);
      await cubit.load();

      final f = (cubit.state as ModListFailure).failure;
      expect(f, isA<ServerFailure>());
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(mapFailureToMessage(f, l10n), 'Server error. Please try again.');
      await cubit.close();
    });
  });

  group('F3 pages entirely filtered out', () {
    test('auto-fetches the next page until something is visible', () async {
      api.handler = (u) => switch (skipOf(u)) {
        0 ||
        20 => (200, [for (var i = 0; i < 20; i++) _card(i, mirrored: false)]),
        40 => (200, [_card(500), _card(501, mirrored: false)]),
        _ => (200, []),
      };
      final cubit = ModListCubit(repo, ModType.bus);
      await cubit.load();

      expect(api.hits('/mods').map(skipOf), [0, 20, 40]);
      final s = cubit.state as ModListSuccess;
      expect(s.items.map((c) => c.sourceId), [500]);
      expect(s.nextSkip, 42);
      await cubit.close();
    });

    test(
      'bounded: never more than $maxEmptyPages consecutive empty fetches',
      () async {
        api.handler = (u) =>
            (200, [for (var i = 0; i < 20; i++) _card(i, mirrored: false)]);
        final cubit = ModListCubit(repo, ModType.bus);
        await cubit.load();

        expect(api.hits('/mods'), hasLength(maxEmptyPages));
        final s = cubit.state as ModListSuccess;
        expect(s.items, isEmpty);
        expect(s.hasMore, isTrue); // the user can still scroll on
        expect(s.nextSkip, 20 * maxEmptyPages);
        await cubit.close();
      },
    );
  });

  group('SearchBloc races over real HTTP timing', () {
    late Map<String, Completer<void>> gates;

    setUp(() {
      gates = {};
      api.handler = (u) async {
        final key = '${u.queryParameters['q']}|${u.queryParameters['type']}';
        await gates[key]?.future;
        return (200, [_card(key.hashCode.abs() % 1000 + 1)]);
      };
    });

    int idFor(String q, String? type) => '$q|$type'.hashCode.abs() % 1000 + 1;

    const settle = Duration(milliseconds: 450);

    test(
      'slow response of the OLD query cannot overwrite the newer query',
      () async {
        gates['bus|null'] = Completer<void>();
        final bloc = SearchBloc(repo)
          ..add(const SearchEvent.queryChanged('bus'));
        await Future<void>.delayed(settle); // 'bus' now in flight
        expect(api.hits('/mods/search'), hasLength(1));

        bloc.add(const SearchEvent.queryChanged('car'));
        await Future<void>.delayed(settle);
        expect((bloc.state as SearchSuccess).query, 'car');

        gates['bus|null']!.complete(); // old answer arrives last
        await Future<void>.delayed(const Duration(milliseconds: 80));

        final s = bloc.state as SearchSuccess;
        expect(s.query, 'car');
        expect(s.items.single.sourceId, idFor('car', null));
        await bloc.close();
      },
    );

    test(
      'slow response for the old TYPE cannot overwrite the newer type',
      () async {
        final bloc = SearchBloc(repo)
          ..add(const SearchEvent.queryChanged('bus'));
        await Future<void>.delayed(settle);
        gates['bus|car'] = Completer<void>();
        bloc.add(const SearchEvent.typeChanged(ModType.car)); // slow
        await Future<void>.delayed(const Duration(milliseconds: 30));
        bloc.add(const SearchEvent.typeChanged(ModType.truck)); // fast
        await Future<void>.delayed(const Duration(milliseconds: 100));
        gates['bus|car']!.complete();
        await Future<void>.delayed(const Duration(milliseconds: 80));

        final s = bloc.state as SearchSuccess;
        expect(s.type, ModType.truck);
        expect(s.items.single.sourceId, idFor('bus', 'truck'));
        await bloc.close();
      },
    );

    test('clearing the field while a slow TYPE search is in flight (a '
        'different event queue) stays initial', () async {
      final bloc = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      gates['bus|car'] = Completer<void>();
      bloc.add(const SearchEvent.typeChanged(ModType.car)); // slow, in flight
      await Future<void>.delayed(const Duration(milliseconds: 30));
      bloc.add(const SearchEvent.queryChanged('')); // user clears the field
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, const SearchState.initial(type: ModType.car));

      gates['bus|car']!.complete(); // late answer
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(bloc.state, const SearchState.initial(type: ModType.car));
      await bloc.close();
    });

    test('clearing below 2 chars while a request is in flight stays initial '
        'when the late answer lands', () async {
      gates['bus|null'] = Completer<void>();
      final bloc = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      bloc.add(const SearchEvent.queryChanged('b'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, const SearchState.initial());

      gates['bus|null']!.complete();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(bloc.state, const SearchState.initial());
      await bloc.close();
    });

    test('a refresh keeps the list (no loading) and a newer query wins over '
        'its late answer', () async {
      final bloc = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      final states = <SearchState>[];
      final sub = bloc.stream.listen(states.add);

      gates['bus|null'] = Completer<void>();
      final done = Completer<Failure?>();
      bloc.add(SearchEvent.refresh(done)); // slow, in flight
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(states, isEmpty); // list stayed, no SearchLoading
      expect((bloc.state as SearchSuccess).query, 'bus');

      bloc.add(const SearchEvent.queryChanged('car'));
      await Future<void>.delayed(settle);
      gates['bus|null']!.complete(); // refresh answer arrives last
      expect(await done.future, isNull);

      final s = bloc.state as SearchSuccess;
      expect(s.query, 'car');
      expect(s.items.single.sourceId, idFor('car', null));
      await sub.cancel();
      await bloc.close();
    });

    test('a refresh that fails over HTTP keeps the old list', () async {
      final bloc = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      final before = bloc.state;
      // 5xx would be served from the HTTP cache by design; 400 is not.
      api.handler = (_) => (400, {'detail': 'bad'});
      final done = Completer<Failure?>();
      bloc.add(SearchEvent.refresh(done));
      expect(await done.future, isNotNull);
      expect(bloc.state, before);
      await bloc.close();
    });
  });

  group('detail errors over real HTTP', () {
    testWidgets('a real 404 shows "no longer available" and NO Retry', (
      t,
    ) async {
      api.handler = (u) => u.path.endsWith('/related')
          ? (200, [])
          : (404, {'message': 'Cannot GET'});
      final cubit = ModDetailCubit(repo);
      await t.pumpWidget(
        _app(
          BlocProvider.value(
            value: cubit,
            child: const ModDetailPage(sourceId: 404),
          ),
        ),
      );
      await t.runAsync(() => cubit.load(404));
      await t.pump();

      expect(find.text('This mod is no longer available'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      await t.runAsync(cubit.close);
    });

    testWidgets('a 500 shows the server error WITH Retry', (t) async {
      api.handler = (u) => (500, {'message': 'boom'});
      final cubit = ModDetailCubit(repo);
      await t.pumpWidget(
        _app(
          BlocProvider.value(
            value: cubit,
            child: const ModDetailPage(sourceId: 9),
          ),
        ),
      );
      await t.runAsync(() => cubit.load(9));
      await t.pump();

      expect(find.text('Server error. Please try again.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(cubit.state, isA<ModDetailFailure>());
      await t.runAsync(cubit.close);
    });
  });

  group('F1: no network image for source hosts, end to end', () {
    const blockedThumbs = [
      'https://www.mediafire.com/t.png',
      'https://download1.mediafire.com/x/t.png',
      'https://f000.backblazeb2.com/file/b/t.png',
      'https://f000.backblaze.com/file/b/t.png',
      'https://evil.example.com@www.mediafire.com/t.png',
    ];

    /// Tall surface so the lazy lists build every tile.
    void tall(WidgetTester t) {
      t.view.physicalSize = const Size(800, 8000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
    }

    Finder networkImages() => find.byWidgetPredicate(
      (w) => w is CachedNetworkImage || (w is Image && w.image is NetworkImage),
    );

    testWidgets('list (real repo + cubit + ModPagedList): blocked thumbnails '
        'build no image; an allowed CDN thumbnail does', (t) async {
      tall(t);
      api.handler = (_) => (
        200,
        [
          for (var i = 0; i < blockedThumbs.length; i++)
            _card(i + 1, thumb: blockedThumbs[i]),
          _card(99, thumb: 'https://img.busmod.test/ok.png'),
        ],
      );
      final cubit = ModListCubit(repo, ModType.bus);
      await t.runAsync(cubit.load);
      final items = (cubit.state as ModListSuccess).items;
      expect(items, hasLength(6));

      await t.pumpWidget(
        _app(
          ModPagedList(
            items: items,
            hasMore: false,
            loadingMore: false,
            onLoadMore: () {},
            onRefresh: () async {},
            onTap: (_) {},
          ),
        ),
      );
      // Control: all 6 tiles are built, but only the allowed CDN host is
      // fetched, never a blocked one.
      for (var i = 1; i <= 5; i++) {
        expect(find.text('Mod $i'), findsOneWidget);
      }
      final built = t
          .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
          .toList();
      expect(built.map((w) => w.imageUrl), ['https://img.busmod.test/ok.png']);
      expect(
        built.map((w) => Uri.parse(w.imageUrl).host),
        everyElement(isNot(contains('mediafire'))),
      );
      for (final w in built) {
        expect(w.imageUrl, isNot(matches('mediafire|backblaze')));
      }
      await t.pump(const Duration(seconds: 1));
      await t.runAsync(cubit.close);
    });

    testWidgets('list: only blocked thumbnails -> zero network images', (
      t,
    ) async {
      tall(t);
      final cards = [
        for (var i = 0; i < blockedThumbs.length; i++)
          ModCard.fromJson(_card(i + 1, thumb: blockedThumbs[i])),
      ];
      await t.pumpWidget(
        _app(
          ModPagedList(
            items: cards,
            hasMore: false,
            loadingMore: false,
            onLoadMore: () {},
            onRefresh: () async {},
            onTap: (_) {},
          ),
        ),
      );
      expect(find.text('Mod 5'), findsOneWidget); // every tile is built
      expect(networkImages(), findsNothing);
      expect(api.requests, isEmpty);
    });

    testWidgets('detail gallery (media.images + thumbnail) and related '
        'strip: zero network images', (t) async {
      tall(t);
      final media = ModMedia.fromJson({
        'thumbnail': blockedThumbs[0],
        'images': blockedThumbs,
      });
      await t.pumpWidget(
        _app(
          ListView(
            children: [
              DetailGallery(media: media),
              DetailRelated(
                related: [
                  for (var i = 0; i < blockedThumbs.length; i++)
                    ModCard.fromJson(_card(i + 1, thumb: blockedThumbs[i])),
                ],
              ),
            ],
          ),
        ),
      );
      expect(
        find.byType(ModImage),
        findsNWidgets(1 + blockedThumbs.length),
      ); // 1 gallery page + related
      expect(networkImages(), findsNothing);
    });

    testWidgets('favorites and downloaded tiles: zero network images', (
      t,
    ) async {
      tall(t);
      await t.pumpWidget(
        _app(
          ListView(
            children: [
              for (final url in blockedThumbs) ...[
                FavoriteTile(
                  record: FavoriteRecord(
                    sourceId: 1,
                    title: 'Fav',
                    thumbUrl: url,
                    type: ModType.bus,
                    savedAtMs: 0,
                  ),
                  onTap: () {},
                  onRemove: () {},
                ),
                DownloadedTile(
                  record: ModDownloadRecord(
                    sourceId: 2,
                    title: 'Dl',
                    thumbUrl: url,
                    type: ModType.bus,
                    relPath: 'mods/2.zip',
                    sizeBytes: 1,
                    createdAtMs: 0,
                  ),
                  onImport: () async {},
                  onDelete: () {},
                ),
              ],
            ],
          ),
        ),
      );
      expect(find.byType(ModImage), findsNWidgets(blockedThumbs.length * 2));
      expect(networkImages(), findsNothing);
      expect(
        find.byIcon(Icons.directions_bus_outlined),
        findsNWidgets(blockedThumbs.length * 2),
      );
    });
  });
}
