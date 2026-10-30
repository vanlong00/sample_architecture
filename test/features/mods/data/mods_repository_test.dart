import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/network/cache_config.dart';
import 'package:busmod/features/mods/data/datasources/mods_remote_datasource.dart';
import 'package:busmod/features/mods/data/models/filter_option.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements ModsRemoteDataSource {}

/// Raw JSON card, as the datasource now returns it.
Map<String, dynamic> card(
  int id, {
  bool mirrored = true,
  String type = 'bus',
}) => {
  'sourceId': id,
  'type': type,
  'title': 't$id',
  'download': {'storageUrl': mirrored ? 'https://cdn/$id.zip' : null},
};

ModDetail detailOf({required bool mirrored}) => ModDetail(
  sourceId: 1,
  type: ModType.bus,
  title: 't',
  download: ModDownload(storageUrl: mirrored ? 'https://cdn/1.zip' : null),
);

T right_<T>(Either<Failure, T> e) =>
    e.getOrElse((f) => fail('expected Right, got $f'));

Failure left_<T>(Either<Failure, T> e) =>
    e.match((f) => f, (_) => fail('expected Left'));

void main() {
  late _MockRemote remote;
  late ModsRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    repo = ModsRepositoryImpl(remote);
  });

  Future<dynamic> stubGetMods() => remote.getMods(
    type: any(named: 'type'),
    category: any(named: 'category'),
    manufacturer: any(named: 'manufacturer'),
    country: any(named: 'country'),
    sort: any(named: 'sort'),
    skip: any(named: 'skip'),
    limit: any(named: 'limit'),
    options: any(named: 'options'),
  );

  group('list', () {
    test('maps query params', () async {
      when(stubGetMods).thenAnswer((_) async => []);
      await repo.list(
        const ModQuery(
          type: ModType.truck,
          sort: ModSort.newest,
          filter: ModFilter(
            categoryId: 'c',
            manufacturerId: 'm',
            countryId: 'k',
          ),
        ),
        skip: 40,
      );
      verify(
        () => remote.getMods(
          type: 'truck',
          category: 'c',
          manufacturer: 'm',
          country: 'k',
          sort: 'newest',
          skip: 40,
          limit: 20,
          options: null,
        ),
      ).called(1);
    });

    test('defaults: popular, no filters', () async {
      when(stubGetMods).thenAnswer((_) async => []);
      await repo.list(const ModQuery(type: ModType.bus), skip: 0);
      verify(
        () => remote.getMods(
          type: 'bus',
          category: null,
          manufacturer: null,
          country: null,
          sort: 'popular',
          skip: 0,
          limit: 20,
          options: null,
        ),
      ).called(1);
    });

    test('F3 filters hidden cards; paging from RAW page', () async {
      final raw = [for (var i = 0; i < 20; i++) card(i, mirrored: i.isEven)];
      when(stubGetMods).thenAnswer((_) async => raw);
      final page = right_(
        await repo.list(const ModQuery(type: ModType.bus), skip: 20),
      );
      expect(page.items, hasLength(10));
      expect(page.items.every((c) => c.isDownloadable), isTrue);
      expect(page.hasMore, isTrue);
      expect(page.nextSkip, 40);
    });

    test('short raw page: hasMore false', () async {
      when(
        stubGetMods,
      ).thenAnswer((_) async => [card(1), card(2, mirrored: false)]);
      final page = right_(
        await repo.list(const ModQuery(type: ModType.bus), skip: 0),
      );
      expect(page.items, hasLength(1));
      expect(page.hasMore, isFalse);
      expect(page.nextSkip, 2);
    });

    test('bad card is skipped and reported; paging from RAW length', () async {
      final raw = <dynamic>[
        for (var i = 0; i < 20; i++)
          if (i == 3)
            card(i, type: 'spaceship') // unknown enum value
          else if (i == 4)
            'not a map'
          else
            card(i),
      ];
      when(stubGetMods).thenAnswer((_) async => raw);
      final page = right_(
        await repo.list(const ModQuery(type: ModType.bus), skip: 20),
      );
      expect(page.items, hasLength(18));
      expect(page.items.map((c) => c.sourceId), isNot(contains(3)));
      expect(page.nextSkip, 40);
      expect(page.hasMore, isTrue);
    });

    test('non-array body -> Left server failure', () async {
      when(stubGetMods).thenAnswer((_) async => {'error': 'x'});
      final f = left_(
        await repo.list(const ModQuery(type: ModType.bus), skip: 0),
      );
      expect(f, isA<ServerFailure>());
    });

    test('datasource error -> Left', () async {
      when(stubGetMods).thenThrow(
        DioException(requestOptions: RequestOptions(), error: Exception('x')),
      );
      final f = left_(
        await repo.list(const ModQuery(type: ModType.bus), skip: 0),
      );
      expect(f, isA<UnknownFailure>());
    });
  });

  group('forceRefresh', () {
    test('list passes forceRefreshOptions only when asked', () async {
      when(stubGetMods).thenAnswer((_) async => []);
      const bus = ModQuery(type: ModType.bus);
      await repo.list(bus, skip: 0);
      await repo.list(bus, skip: 0, forceRefresh: true);
      final opts = verify(
        () => remote.getMods(
          type: any(named: 'type'),
          category: any(named: 'category'),
          manufacturer: any(named: 'manufacturer'),
          country: any(named: 'country'),
          sort: any(named: 'sort'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          options: captureAny(named: 'options'),
        ),
      ).captured;
      expect(opts.first, isNull);
      expect((opts.last as Options).extra, forceRefreshOptions().extra);
    });

    test('search passes forceRefreshOptions only when asked', () async {
      when(
        () => remote.search(
          q: any(named: 'q'),
          type: any(named: 'type'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => []);
      await repo.search(query: 'x', skip: 0);
      await repo.search(query: 'x', skip: 0, forceRefresh: true);
      final opts = verify(
        () => remote.search(
          q: any(named: 'q'),
          type: any(named: 'type'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          options: captureAny(named: 'options'),
        ),
      ).captured;
      expect(opts.first, isNull);
      expect((opts.last as Options).extra, forceRefreshOptions().extra);
    });
  });

  group('search', () {
    test('params + F3 + raw paging', () async {
      when(
        () => remote.search(
          q: 'volvo',
          type: 'bus',
          skip: 0,
          limit: 20,
          options: null,
        ),
      ).thenAnswer((_) async => [card(1), card(2, mirrored: false)]);
      final page = right_(
        await repo.search(query: 'volvo', type: ModType.bus, skip: 0),
      );
      expect(page.items.map((c) => c.sourceId), [1]);
      expect(page.nextSkip, 2);
      expect(page.hasMore, isFalse);
    });

    test('bad card skipped, rest kept', () async {
      when(
        () => remote.search(
          q: 'x',
          type: null,
          skip: 0,
          limit: 20,
          options: null,
        ),
      ).thenAnswer((_) async => [card(1, type: 'zeppelin'), card(2)]);
      final page = right_(await repo.search(query: 'x', skip: 0));
      expect(page.items.map((c) => c.sourceId), [2]);
      expect(page.nextSkip, 2);
    });

    test('type omitted -> null', () async {
      when(
        () => remote.search(
          q: 'x',
          type: null,
          skip: 20,
          limit: 20,
          options: null,
        ),
      ).thenAnswer((_) async => []);
      right_(await repo.search(query: 'x', skip: 20));
      verify(
        () => remote.search(
          q: 'x',
          type: null,
          skip: 20,
          limit: 20,
          options: null,
        ),
      ).called(1);
    });
  });

  group('detail', () {
    test('mirrored -> Right', () async {
      when(
        () => remote.getMod(1),
      ).thenAnswer((_) async => detailOf(mirrored: true));
      expect(right_(await repo.detail(1)).sourceId, 1);
    });

    test('not downloadable -> Left server 404', () async {
      when(
        () => remote.getMod(1),
      ).thenAnswer((_) async => detailOf(mirrored: false));
      final f = left_(await repo.detail(1));
      expect(f, isA<ServerFailure>());
      expect((f as ServerFailure).code, 404);
    });

    test('datasource error -> Left', () async {
      when(() => remote.getMod(1)).thenThrow(Exception('boom'));
      expect(left_(await repo.detail(1)), isA<UnknownFailure>());
    });
  });

  group('related', () {
    test('F3 filtered, default limit', () async {
      when(
        () => remote.getRelated(5),
      ).thenAnswer((_) async => [card(1), card(2, mirrored: false)]);
      expect(right_(await repo.related(5)).map((c) => c.sourceId), [1]);
    });

    test('bad card skipped', () async {
      when(
        () => remote.getRelated(5),
      ).thenAnswer((_) async => [card(1, type: 'zeppelin'), card(2)]);
      expect(right_(await repo.related(5)).map((c) => c.sourceId), [2]);
    });

    test('error -> Left', () async {
      when(() => remote.getRelated(5)).thenThrow(Exception('x'));
      expect(left_(await repo.related(5)), isA<UnknownFailure>());
    });
  });

  group('filterOptions', () {
    const opt = FilterOption(id: 'a', name: 'A');

    test('success runs the 3 calls with type', () async {
      when(() => remote.getCategories('car')).thenAnswer((_) async => [opt]);
      when(() => remote.getManufacturers('car')).thenAnswer((_) async => []);
      when(
        () => remote.getCountries('car'),
      ).thenAnswer((_) async => [opt, opt]);
      final r = right_(await repo.filterOptions(ModType.car));
      expect(r.categories, [opt]);
      expect(r.manufacturers, isEmpty);
      expect(r.countries, hasLength(2));
    });

    test('one failing -> Left', () async {
      when(() => remote.getCategories('car')).thenAnswer((_) async => [opt]);
      when(() => remote.getManufacturers('car')).thenThrow(Exception('x'));
      when(() => remote.getCountries('car')).thenAnswer((_) async => []);
      expect(left_(await repo.filterOptions(ModType.car)), isA<Failure>());
    });
  });
}
