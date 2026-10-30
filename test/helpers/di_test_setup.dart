import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/storage/local_store.dart';

import 'isar_test_setup.dart';

/// Runs the real `configureDependencies` against a temp documents directory
/// (path_provider channel mocked, IsarCore loaded). Pair with [tearDownDi].
Future<Directory> setUpDi([AppEnv env = AppEnv.dev]) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initIsarCoreForTests();
  final dir = await Directory.systemTemp.createTemp('busmod_di_test');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (call) async => dir.path,
      );
  await configureDependencies(env);
  return dir;
}

Future<void> tearDownDi(Directory dir) async {
  await getIt<LocalStore>().close();
  await getIt<CacheStore>().close();
  await getIt.reset();
  await dir.delete(recursive: true);
}
