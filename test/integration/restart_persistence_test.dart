// "App restart" = close the real LocalStore (Isar) and reopen it on the same
// directory, then build FRESH cubits/services on top. Maps US7, US8, US9, US11.
import 'dart:io';

import 'package:busmod/core/ads/ad_network.dart';
import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/analytics/remote_config_service.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_state.dart';
import 'package:busmod/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:busmod/features/favorites/data/repositories/favorites_repository.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/settings/presentation/bloc/locale_cubit.dart';
import 'package:busmod/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/isar_test_setup.dart';

class _MockRemoteConfig extends Mock implements RemoteConfigService {}

class _MockLookup extends Mock implements AdCountryLookup {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() async => store.close(deleteFromDisk: true));

  /// Process restart: same directory, brand new store instance.
  Future<void> restart() async {
    final dir = store.directory!;
    await store.close();
    store = LocalStore();
    await store.init(directory: dir);
  }

  test(
    'US11: theme and language chosen before a restart are restored',
    () async {
      ThemeCubit(store).setMode(ThemeMode.dark);
      LocaleCubit(store).setLocale(const Locale('vi'));
      await pumpEventQueue(); // writes are unawaited inside the cubits
      await Future<void>.delayed(const Duration(milliseconds: 200));

      await restart();

      expect(ThemeCubit(store).state, ThemeMode.dark);
      expect(LocaleCubit(store).state, const Locale('vi'));
    },
  );

  test(
    'US9: removeAds survives a restart and a fresh AdsService blocks ads',
    () async {
      final config = _MockRemoteConfig();
      when(() => config.getBool(RemoteConfigKeys.adsEnabled)).thenReturn(true);
      final ads = AdsService(store, config, _MockLookup());
      expect(ads.adsAllowed, isTrue);
      await ads.setRemoveAds(true);
      ads.dispose();

      await restart();

      final fresh = AdsService(store, config, _MockLookup());
      expect(fresh.removeAds, isTrue);
      expect(
        fresh.adsAllowed,
        isFalse,
      ); // banner/native/interstitial/app-open gate
      expect(fresh.canShowAds, isFalse);
      fresh.dispose();
    },
  );

  test(
    'US8: heart toggle persists; list rebuilds from the snapshot, offline',
    () async {
      FavoritesCubit cubit() => FavoritesCubit(
        FavoritesRepositoryImpl(FavoritesLocalDataSource(store)),
      );
      const mod = ModDetail(
        sourceId: 9,
        type: ModType.truck,
        title: 'Big Rig',
        media: ModMedia(thumbnail: 'https://img.busmod.test/9.png'),
        download: ModDownload(storageUrl: 'https://cdn.busmod.test/9.zip'),
      );
      final first = cubit();
      await first.load();
      await first.toggle(mod);
      expect(first.state.isFavorite(9), isTrue);
      await first.close();

      await restart(); // no network anywhere in this test

      final second = cubit();
      expect(second.state.isFavorite(9), isFalse); // not loaded yet
      await second.load();
      final items = (second.state as FavoritesSuccess).items;
      expect(items.single.sourceId, 9);
      expect(items.single.title, 'Big Rig');
      expect(items.single.thumbUrl, 'https://img.busmod.test/9.png');
      expect(items.single.type, ModType.truck);
      expect(second.state.isFavorite(9), isTrue);

      await second.toggle(mod); // un-heart
      await second.close();
      await restart();
      final third = cubit();
      await third.load();
      expect((third.state as FavoritesSuccess).items, isEmpty);
      await third.close();
    },
  );

  test(
    'US7: library after a restart lists snapshot rows and deletes file + record',
    () async {
      final support = await Directory.systemTemp.createTemp(
        'busmod_lib_support',
      );
      addTearDown(() => support.delete(recursive: true));
      DownloadedCubit cubit() => DownloadedCubit(
        DownloadRepositoryImpl(
          DownloadRemoteDataSource(Dio()), // never used: no network offline
          DownloadLocalDataSource(store, supportDir: () async => support.path),
          PbsuLauncherDataSource(),
        ),
      );
      Directory('${support.path}/mods').createSync();
      File('${support.path}/mods/1.zip').writeAsBytesSync(List.filled(10, 1));
      File('${support.path}/mods/2.RAR').writeAsBytesSync(List.filled(30, 1));
      final local = DownloadLocalDataSource(
        store,
        supportDir: () async => support.path,
      );
      for (final (id, rel, size, at) in [
        (1, 'mods/1.zip', 10, 1),
        (2, 'mods/2.RAR', 30, 2),
      ]) {
        await local.writeRecord(
          ModDownloadRecord(
            sourceId: id,
            title: 'Removed from catalog $id',
            thumbUrl: 'https://img.busmod.test/$id.png',
            type: ModType.bus,
            relPath: rel,
            sizeBytes: size,
            createdAtMs: at,
          ),
        );
      }

      await restart();

      final c = cubit();
      await c.load();
      var s = c.state as DownloadedSuccess;
      expect(s.records.map((r) => r.title), [
        'Removed from catalog 2',
        'Removed from catalog 1',
      ]);
      expect(s.records.map((r) => r.extension), ['RAR', 'zip']);
      expect(s.records.map((r) => r.thumbUrl), everyElement(isNotNull));
      expect(s.totalBytes, 40);

      await c.delete(s.records.first);
      await pumpEventQueue(); // list refreshes via the repository changes stream
      s = c.state as DownloadedSuccess;
      expect(s.records.single.sourceId, 1);
      expect(s.totalBytes, 10);
      expect(File('${support.path}/mods/2.RAR').existsSync(), isFalse);
      expect(File('${support.path}/mods/1.zip').existsSync(), isTrue);
      await c.close();
    },
  );
}
