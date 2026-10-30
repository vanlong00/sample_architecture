// Hermetic multi-layer tests: REAL Dio (buildDio / buildDownloadDio, cache and
// error interceptors) + REAL retrofit data sources + REAL repositories +
// REAL cubits/blocs + REAL LocalStore and file system. Only the HTTP adapter
// (in-memory fake server), the PBSU method channel and the support dir are
// faked. They map PRD criteria US1-US5, US10, F1-F3 onto the whole stack.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/network/cache_config.dart';
import 'package:busmod/core/network/data_version_remote_datasource.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:busmod/core/services/cache_sync_service.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart';
import 'package:busmod/features/downloads/data/logic/mod_file.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/download_manager.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_state.dart';
import 'package:busmod/features/downloads/presentation/widgets/download_cta.dart';
import 'package:busmod/features/mods/data/datasources/mods_remote_datasource.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_state.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_state.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:busmod/features/mods/presentation/pages/mod_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/isar_test_setup.dart';

const _api = 'api.busmod.test';
const _cdn = 'cdn.busmod.test';
const _mediafire = 'https://www.mediafire.com/file/abc/source.rar/file';
const _config = AppConfig(
  env: AppEnv.dev,
  baseUrl: 'https://$_api',
  enableLogging: false,
  appName: 'Busmod (Test)',
);

/// In-memory server for both the API host and the file (storage) host.
class _Server implements HttpClientAdapter {
  final requests = <Uri>[];

  /// Items returned by `GET /mods` and `/mods/search` per `skip`.
  final Map<int, int> pageSizeBySkip = {};

  /// Version returned by `/data-version`.
  int dataVersion = 1;

  /// Bytes served by the storage host, in [chunks] pieces.
  int fileBytes = 100;
  int chunks = 4;

  /// When set, the storage host stalls before the 3rd chunk until completed.
  Completer<void>? stall;
  int fileStatus = 200;

  Iterable<Uri> to(String host) => requests.where((u) => u.host == host);
  Iterable<Uri> hits(String path) =>
      requests.where((u) => u.host == _api && u.path == path);

  Map<String, dynamic> _card(int id, {bool mirrored = true}) => {
    'sourceId': id,
    'type': 'bus',
    'title': 'Bus $id',
    'media': {'thumbnail': 'https://img.busmod.test/$id.png'},
    // The raw API also exposes the third-party source `url` (F1).
    'download': {
      'url': _mediafire,
      if (mirrored) 'storageUrl': 'https://$_cdn/files/$id.rar',
      'sizeBytes': 100,
    },
  };

  ResponseBody _json(Object body, [int status = 200]) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final uri = options.uri;
    requests.add(uri);
    if (uri.host == _cdn) return _file();
    if (uri.host != _api) return _json({'unexpected': uri.host}, 500);

    final path = uri.path;
    final skip = int.tryParse(uri.queryParameters['skip'] ?? '') ?? 0;
    if (path == '/mods' || path == '/mods/search') {
      final n = pageSizeBySkip[skip] ?? 0;
      return _json([for (var i = 0; i < n; i++) _card(1000 + skip + i)]);
    }
    if (path == '/data-version') return _json({'version': dataVersion});
    if (path == '/categories' ||
        path == '/manufacturers' ||
        path == '/countries') {
      return _json([
        {
          '_id': 'x1',
          'name': 'Opt',
          'modCount': {'bus': 5},
        },
      ]);
    }
    final m = RegExp(r'^/mods/(\d+)(/related)?$').firstMatch(path);
    if (m != null) {
      final id = int.parse(m[1]!);
      if (m[2] != null) {
        return _json([_card(77), _card(78, mirrored: false)]);
      }
      return switch (id) {
        // 2 is not mirrored (F3).
        2 => _json({..._card(2, mirrored: false), 'specs': []}),
        _ => _json({
          ..._card(id),
          'specs': [
            {'group': 'Engine', 'label': 'Power', 'value': '300'},
          ],
          'contentHtml': '<p>Hello</p>',
        }),
      };
    }
    return _json({'error': 'nope'}, 404);
  }

  ResponseBody _file() {
    if (fileStatus != 200) {
      return ResponseBody.fromString('boom', fileStatus);
    }
    final size = fileBytes;
    final per = size ~/ chunks;
    Stream<Uint8List> body() async* {
      for (var i = 0; i < chunks; i++) {
        if (i == 2 && stall != null) await stall!.future;
        yield Uint8List.fromList(List.filled(per, i));
      }
    }

    return ResponseBody(
      body(),
      200,
      headers: {
        Headers.contentLengthHeader: ['${per * chunks}'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ModDetail _mod(int id, String storageUrl) => ModDetail(
  sourceId: id,
  type: ModType.bus,
  title: 'Mod $id',
  media: const ModMedia(thumbnail: 'https://img.busmod.test/t.png'),
  download: ModDownload(storageUrl: storageUrl),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Server server;
  late MemCacheStore cache;
  late Dio dio;
  late LocalStore store;
  late Directory support;
  late ModsRepositoryImpl mods;
  late DownloadLocalDataSource local;
  late DownloadRepositoryImpl downloads;
  late DownloadManager manager;
  late List<MethodCall> channelCalls;
  const channel = MethodChannel('com.pamg.busmod/pbsu');

  setUp(() async {
    server = _Server();
    cache = MemCacheStore();
    dio = buildDio(_config, cache)..httpClientAdapter = server;
    final dlDio = buildDownloadDio(_config)..httpClientAdapter = server;
    store = await openTestStore();
    support = await Directory.systemTemp.createTemp('busmod_flow_support');
    mods = ModsRepositoryImpl(ModsRemoteDataSource(dio));
    local = DownloadLocalDataSource(
      store,
      supportDir: () async => support.path,
    );
    channelCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          channelCalls.add(call);
          return call.method == 'isInstalled' ? true : null;
        });
    downloads = DownloadRepositoryImpl(
      DownloadRemoteDataSource(dlDio),
      local,
      PbsuLauncherDataSource(channel: channel),
    );
    manager = DownloadManager(downloads);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await store.close(deleteFromDisk: true);
    await support.delete(recursive: true);
  });

  group('US1/US2 browse + filter, real HTTP contract', () {
    test(
      'first page asks /mods?type=bus&sort=popular&skip=0&limit=20',
      () async {
        server.pageSizeBySkip[0] = 3;
        final cubit = ModListCubit(mods, ModType.bus);
        await cubit.load();
        expect(server.hits('/mods').single.queryParameters, {
          'type': 'bus',
          'sort': 'popular',
          'skip': '0',
          'limit': '20',
        });
        expect((cubit.state as ModListSuccess).items, hasLength(3));
        await cubit.close();
      },
    );

    test(
      'exactly 20 -> more; a 19 page ends paging with no extra GET',
      () async {
        server.pageSizeBySkip.addAll({0: 20, 20: 19});
        final cubit = ModListCubit(mods, ModType.bus);
        await cubit.load();
        expect((cubit.state as ModListSuccess).hasMore, isTrue);

        await cubit.loadMore();
        final s = cubit.state as ModListSuccess;
        expect(s.items, hasLength(39));
        expect(s.hasMore, isFalse);
        expect(server.hits('/mods').last.queryParameters['skip'], '20');

        await cubit.loadMore(); // nothing left
        expect(server.hits('/mods'), hasLength(2));
        await cubit.close();
      },
    );

    test('a 19 item first page has no next page', () async {
      server.pageSizeBySkip[0] = 19;
      final cubit = ModListCubit(mods, ModType.bus);
      await cubit.load();
      expect((cubit.state as ModListSuccess).hasMore, isFalse);
      await cubit.loadMore();
      expect(server.hits('/mods'), hasLength(1));
      await cubit.close();
    });

    test('Newest reloads from the top; filters become query params', () async {
      server.pageSizeBySkip.addAll({0: 20, 20: 20});
      final cubit = ModListCubit(mods, ModType.bus);
      await cubit.load();
      await cubit.loadMore();
      await cubit.setSort(ModSort.newest);
      var q = server.hits('/mods').last.queryParameters;
      expect(q['sort'], 'newest');
      expect(q['skip'], '0');
      expect((cubit.state as ModListSuccess).items, hasLength(20));

      await cubit.setFilter(
        const ModFilter(
          categoryId: 'c1',
          manufacturerId: 'm1',
          countryId: 'k1',
        ),
      );
      q = server.hits('/mods').last.queryParameters;
      expect(
        [q['category'], q['manufacturer'], q['country'], q['skip']],
        ['c1', 'm1', 'k1', '0'],
      );
      await cubit.close();
    });

    test('filter options come from the three type-scoped endpoints', () async {
      final r = await mods.filterOptions(ModType.bus);
      final opts = r.getOrElse((f) => fail('$f'));
      for (final p in ['/categories', '/manufacturers', '/countries']) {
        expect(server.hits(p).single.queryParameters, {'type': 'bus'});
      }
      expect(opts.categories.single.countFor(ModType.bus), 5);
    });
  });

  group('US3 search, real HTTP', () {
    test(
      'keystrokes cost nothing; ONE /mods/search?q= after the debounce',
      () async {
        server.pageSizeBySkip[0] = 2;
        final bloc = SearchBloc(mods);
        bloc.add(const SearchEvent.queryChanged('b'));
        bloc.add(const SearchEvent.queryChanged('bu'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const SearchEvent.queryChanged('bus'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(server.hits('/mods/search'), isEmpty);

        await bloc.stream.firstWhere((s) => s is SearchSuccess);
        final hit = server.hits('/mods/search').single;
        expect(hit.queryParameters['q'], 'bus');
        await Future<void>.delayed(SearchBloc.debounce * 2);
        expect(server.hits('/mods/search'), hasLength(1));
        await bloc.close();
      },
    );

    test('no results -> success with empty items', () async {
      final bloc = SearchBloc(mods)..add(const SearchEvent.queryChanged('zzz'));
      final s = await bloc.stream.firstWhere((s) => s is SearchSuccess);
      expect((s as SearchSuccess).items, isEmpty);
      await bloc.close();
    });
  });

  group('US4/US5/F1/F2 list -> detail -> download -> import', () {
    test(
      'only the storageUrl host serves the file; mediafire is never contacted',
      () async {
        server.pageSizeBySkip[0] = 1;
        final list = ModListCubit(mods, ModType.bus);
        await list.load();

        final detailCubit = ModDetailCubit(mods);
        await detailCubit.load(5);
        final ok = detailCubit.state as ModDetailSuccess;
        expect(server.hits('/mods/5'), hasLength(1));
        expect(server.hits('/mods/5/related').single.queryParameters, {
          'limit': '8',
        });
        expect(ok.mod.specs.single.group, 'Engine');
        expect(ok.mod.contentHtml, '<p>Hello</p>');
        expect(ok.related.map((c) => c.sourceId), [77]); // 78 not mirrored (F3)

        // F1: nothing the UI can read carries the source url.
        for (final exposed in [
          list.state.toString(),
          ok.toString(),
          jsonEncode(ok.mod.toJson()),
        ]) {
          expect(exposed, isNot(contains('mediafire')));
        }

        final dl = ModDownloadCubit(downloads, manager);
        final states = <ModDownloadState>[];
        final sub = dl.stream.listen(states.add);
        await dl.start(ok.mod);
        await pumpEventQueue();
        await sub.cancel();

        final progress = [
          for (final s in states)
            if (s is ModDownloadDownloading && s.total > 0)
              s.received * 100 ~/ s.total,
        ];
        expect(progress, [25, 50, 75, 100]);
        expect(progress.every((p) => p >= 0 && p <= 100), isTrue);
        final done = dl.state as ModDownloadDownloaded;
        expect(done.record.relPath, 'mods/5.rar');
        expect(done.record.title, 'Bus 5');
        expect(done.record.thumbUrl, 'https://img.busmod.test/5.png');
        expect(done.record.sizeBytes, 100);
        expect(File('${support.path}/mods/5.rar').lengthSync(), 100);

        // F1: only api + storage hosts, the file only from storageUrl.
        expect(server.requests.map((u) => u.host).toSet(), {_api, _cdn});
        expect(server.to(_cdn).map((u) => '$u'), ['https://$_cdn/files/5.rar']);
        expect(
          server.requests.where(
            (u) => RegExp('mediafire|backblaze|backblazeb2').hasMatch('$u'),
          ),
          isEmpty,
        );

        // US6/F2: launcher gets the saved file and importMimeFor(ext).
        await dl.importToGame(done.record);
        final launch = channelCalls.singleWhere((c) => c.method == 'launch');
        expect(launch.arguments['path'], '${support.path}/mods/5.rar');
        expect(launch.arguments['mime'], importMimeFor('rar'));
        await dl.close();
        await list.close();
        await detailCubit.close();
      },
    );

    for (final ext in ['rar', 'zip', 'RAR', 'Zip']) {
      test('F2: .$ext saved as <id>.$ext, same ext + mime to PBSU', () async {
        final mod = _mod(31, 'https://$_cdn/files/pack.$ext?sig=1');
        final dl = ModDownloadCubit(downloads, manager);
        await dl.start(mod);
        final rec = (dl.state as ModDownloadDownloaded).record;
        expect(rec.relPath, 'mods/31.$ext');
        expect(File('${support.path}/mods/31.$ext').existsSync(), isTrue);
        expect(Directory('${support.path}/mods').listSync(), hasLength(1));

        await dl.importToGame(rec);
        final launch = channelCalls.singleWhere((c) => c.method == 'launch');
        expect(launch.arguments['path'], endsWith('/mods/31.$ext'));
        expect(launch.arguments['mime'], importMimeFor(ext));
        await dl.close();
      });
    }

    test('re-download overwrites the single file and record', () async {
      final mod = _mod(40, 'https://$_cdn/files/a.zip');
      final dl = ModDownloadCubit(downloads, manager);
      await dl.start(mod);
      server.fileBytes = 200;
      await dl.start(mod);
      expect(Directory('${support.path}/mods').listSync(), hasLength(1));
      expect(File('${support.path}/mods/40.zip').lengthSync(), 200);
      expect(local.readRecords().single.sizeBytes, 200);
      await dl.close();
    });

    test(
      'Cancel mid-download: partial file gone, no record, CTA back to Download',
      () async {
        server.stall = Completer<void>();
        final mod = _mod(50, 'https://$_cdn/files/a.rar');
        final dl = ModDownloadCubit(downloads, manager);
        final running = dl.start(mod);
        await dl.stream.firstWhere(
          (s) => s is ModDownloadDownloading && s.received > 0,
        );
        expect(File('${support.path}/mods/50.rar.part').existsSync(), isTrue);

        dl.cancel();
        server.stall!.complete();
        await running;

        await dl.check(50); // settles the post-cancel re-resolve
        expect(dl.state, const ModDownloadState.idle());
        expect(File('${support.path}/mods/50.rar').existsSync(), isFalse);
        expect(File('${support.path}/mods/50.rar.part').existsSync(), isFalse);
        expect(local.readRecord(50), isNull);
        await dl.check(50);
        expect(dl.state, const ModDownloadState.idle());
        await dl.close();
      },
    );

    test(
      'leaving the page keeps the transfer; reopening shows live progress',
      () async {
        server.stall = Completer<void>();
        final mod = _mod(70, 'https://$_cdn/files/a.rar');
        final first = ModDownloadCubit(downloads, manager);
        unawaited(first.start(mod));
        await first.stream.firstWhere(
          (s) => s is ModDownloadDownloading && s.received > 0,
        );
        await first.close(); // back button

        final second = ModDownloadCubit(downloads, manager);
        expect(second.state, const ModDownloadState.checking());
        await second.check(70);
        expect(second.state, isA<ModDownloadDownloading>());
        // a second start (detail A -> related -> A) attaches, no 2nd request
        unawaited(second.start(mod));

        server.stall!.complete();
        await second.stream.firstWhere((s) => s is ModDownloadDownloaded);
        expect(File('${support.path}/mods/70.rar').lengthSync(), 100);
        expect(server.to(_cdn), hasLength(1));
        await second.close();
      },
    );

    test('failed re-download keeps the old file and record', () async {
      final mod = _mod(80, 'https://$_cdn/files/a.zip');
      final dl = ModDownloadCubit(downloads, manager);
      await dl.start(mod);
      server.fileStatus = 500;
      await dl.start(mod);
      expect(dl.state, isA<ModDownloadFailure>());
      expect(File('${support.path}/mods/80.zip').lengthSync(), 100);
      expect(local.readRecord(80)!.sizeBytes, 100);
      await dl.close();
    });

    test('server error: failure, no file, no record', () async {
      server.fileStatus = 500;
      final dl = ModDownloadCubit(downloads, manager);
      await dl.start(_mod(60, 'https://$_cdn/files/a.rar'));
      expect(dl.state, isA<ModDownloadFailure>());
      expect(File('${support.path}/mods/60.rar').existsSync(), isFalse);
      expect(local.readRecord(60), isNull);
      await dl.close();
    });
  });

  group('F3 not mirrored never reaches the user', () {
    test(
      'detail of a mod without storageUrl fails; no file request ever',
      () async {
        final cubit = ModDetailCubit(mods);
        await cubit.load(2);
        expect(cubit.state, isA<ModDetailFailure>());
        expect(server.to(_cdn), isEmpty);
        await cubit.close();
      },
    );

    testWidgets(
      'detail page shows localized 404 message, no Retry, no CTA, no raw text',
      (t) async {
        final cubit = ModDetailCubit(mods);
        await t.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: BlocProvider.value(
              value: cubit,
              child: const ModDetailPage(sourceId: 2),
            ),
          ),
        );
        await t.runAsync(() => cubit.load(2));
        await t.pump();

        // 404 (not mirrored): "no longer available", nothing to retry.
        expect(find.text('This mod is no longer available'), findsOneWidget);
        expect(find.text('Retry'), findsNothing);
        expect(find.byType(DownloadCta), findsNothing);
        expect(find.textContaining('Exception'), findsNothing);
        expect(find.textContaining('404'), findsNothing);
        expect(find.textContaining('mediafire'), findsNothing);
        await t.runAsync(cubit.close);
      },
    );
  });

  group('US10 HTTP cache + data-version, real interceptors', () {
    CacheSyncService sync() =>
        CacheSyncService(DataVersionRemoteDataSource(dio), store, cache);

    test(
      'GETs are served from cache; a data-version change clears it',
      () async {
        server.pageSizeBySkip[0] = 1;
        Future<void> fetch() =>
            mods.list(const ModQuery(type: ModType.bus), skip: 0);

        await sync().syncIfStale(); // first boot: stores version 1
        await fetch();
        await fetch();
        expect(server.hits('/mods'), hasLength(1)); // second from cache

        await sync().syncIfStale(); // same version: cache kept
        await fetch();
        expect(server.hits('/mods'), hasLength(1));

        server.dataVersion = 2;
        await sync().syncIfStale();
        await fetch();
        expect(server.hits('/mods'), hasLength(2)); // cleared -> network
        expect(store.read<int>(StoreBoxes.settings, 'data_version'), 2);
        // /data-version itself is never cached (always asks the server).
        expect(server.hits('/data-version'), hasLength(3));
      },
    );

    test('responses are cached for 3 days', () {
      expect(kCacheTtl, const Duration(days: 3));
    });
  });
}
