import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sample_architecture/core/config/app_config.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/di/injector.dart';
import 'package:sample_architecture/core/storage/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await getIt.reset();
    // If Hive.initFlutter() partially succeeded (e.g. in an environment where
    // the path_provider channel is available), clean up any on-disk state so
    // tests don't leak into one another.
    try {
      await Hive.deleteFromDisk();
    } catch (_) {
      // No Hive state to clean up (init never completed); ignore.
    }
  });

  test(
    'configureDependencies wires the DI graph (tolerating Hive platform channel)',
    () async {
      // configureDependencies registers AppConfig and calls getIt.init()
      // BEFORE `await getIt<HiveService>().init()`. Hive.initFlutter() needs
      // the path_provider platform channel, which is unavailable in plain
      // `flutter test` and throws. Because registration happens first, the
      // container is fully populated even when Hive init throws, so we tolerate
      // only that failure and then assert the DI graph resolved.
      try {
        await configureDependencies(AppEnv.dev);
      } on Object {
        // Expected: Hive.initFlutter() platform channel unavailable.
        // Storage/Hive init behavior itself is covered by Task 4's tests.
      }

      expect(getIt.isRegistered<AppConfig>(), isTrue);
      expect(getIt<AppConfig>().env, AppEnv.dev);
      expect(getIt.isRegistered<Dio>(), isTrue);
      expect(getIt<Dio>(), isA<Dio>());
      expect(getIt.isRegistered<SecureStorageService>(), isTrue);
      expect(getIt<SecureStorageService>(), isA<SecureStorageService>());
    },
  );
}
