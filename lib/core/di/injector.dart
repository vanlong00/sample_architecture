import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http_cache_isar_store/http_cache_isar_store.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';
import '../config/env.dart';
import '../network/dio_client.dart';
import '../storage/local_store.dart';
import 'injector.config.dart';

final GetIt getIt = GetIt.instance;

// AppConfig and CacheStore are registered by hand in `configureDependencies`.
@InjectableInit(ignoreUnregisteredTypes: [AppConfig, CacheStore])
Future<void> configureDependencies(AppEnv env) async {
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnv(env));
  getIt.init();

  final cacheStore = await _buildCacheStore();
  await _awaitFirstOpen(cacheStore);
  getIt.registerSingleton<CacheStore>(cacheStore);
  await getIt<LocalStore>().init();
}

Future<void> _awaitFirstOpen(CacheStore store) async {
  try {
    await store.exists('__warmup__');
  } catch (error) {
    debugPrint('[Cache] warmup failed: $error');
  }
}

Future<CacheStore> _buildCacheStore() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    return IsarCacheStore(dir.path);
  } on Object {
    return MemCacheStore();
  }
}

@module
abstract class RegisterModule {
  @lazySingleton
  LocalStore get localStore => LocalStore();

  @lazySingleton
  Dio dio(AppConfig config, CacheStore store) => buildDio(config, store);

  /// Separate from the API client: absolute CDN URLs, no cache, long timeout.
  @Named('download')
  @lazySingleton
  Dio downloadDio(AppConfig config) => buildDownloadDio(config);
}
