import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/network/data_version_model.dart';
import 'package:busmod/core/network/data_version_remote_datasource.dart';
import 'package:busmod/core/services/cache_sync_service.dart';
import 'package:busmod/core/storage/local_store.dart';

class _MockRemote extends Mock implements DataVersionRemoteDataSource {}

class _MockLocalStore extends Mock implements LocalStore {}

class _MockStore extends Mock implements CacheStore {}

void main() {
  late _MockRemote remote;
  late _MockLocalStore local;
  late _MockStore store;
  late CacheSyncService service;

  setUpAll(() {
    registerFallbackValue(CachePriority.normal);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocalStore();
    store = _MockStore();
    service = CacheSyncService(remote, local, store);

    when(
      () => store.clean(
        priorityOrBelow: any(named: 'priorityOrBelow'),
        staleOnly: any(named: 'staleOnly'),
      ),
    ).thenAnswer((_) async {});
    when(() => local.write<int>(any(), any(), any())).thenAnswer((_) async {});
  });

  void givenRemote(int version) {
    when(
      () => remote.getVersion(options: any(named: 'options')),
    ).thenAnswer((_) async => DataVersionModel(version: version));
  }

  void givenLocal(int? version) {
    when(
      () => local.read<int>(StoreBoxes.settings, CacheSyncService.versionKey),
    ).thenReturn(version);
  }

  void verifyNoClear() {
    verifyNever(
      () => store.clean(
        priorityOrBelow: any(named: 'priorityOrBelow'),
        staleOnly: any(named: 'staleOnly'),
      ),
    );
    verifyNever(() => local.write<int>(any(), any(), any()));
  }

  test('same version: cache kept, nothing written', () async {
    givenRemote(100);
    givenLocal(100);

    await service.syncIfStale();

    verifyNoClear();
  });

  test('version changed: cache cleared, new version stored', () async {
    givenRemote(200);
    givenLocal(100);

    await service.syncIfStale();

    verify(
      () => store.clean(
        priorityOrBelow: any(named: 'priorityOrBelow'),
        staleOnly: any(named: 'staleOnly'),
      ),
    ).called(1);
    verify(
      () => local.write<int>(
        StoreBoxes.settings,
        CacheSyncService.versionKey,
        200,
      ),
    ).called(1);
  });

  test('no stored version: treated as changed', () async {
    givenRemote(200);
    givenLocal(null);

    await service.syncIfStale();

    verify(
      () => local.write<int>(
        StoreBoxes.settings,
        CacheSyncService.versionKey,
        200,
      ),
    ).called(1);
  });

  test('server error/offline: cache kept, does not throw', () async {
    when(() => remote.getVersion(options: any(named: 'options'))).thenThrow(
      DioException.connectionError(
        requestOptions: RequestOptions(path: '/data-version'),
        reason: 'offline',
      ),
    );
    givenLocal(100);

    await service.syncIfStale();

    verifyNoClear();
  });

  test(
    'clean() fails: does not throw, version not stored (retry next boot)',
    () async {
      givenRemote(200);
      givenLocal(100);
      when(
        () => store.clean(
          priorityOrBelow: any(named: 'priorityOrBelow'),
          staleOnly: any(named: 'staleOnly'),
        ),
      ).thenThrow(CacheException());

      await service.syncIfStale(); // never throws

      verifyNever(() => local.write<int>(any(), any(), any()));
    },
  );

  test('broken store read: treated as changed, cache cleared', () async {
    givenRemote(200);
    when(
      () => local.read<int>(StoreBoxes.settings, CacheSyncService.versionKey),
    ).thenThrow(CacheException());

    await service.syncIfStale();

    verify(
      () => store.clean(
        priorityOrBelow: any(named: 'priorityOrBelow'),
        staleOnly: any(named: 'staleOnly'),
      ),
    ).called(1);
  });
}
