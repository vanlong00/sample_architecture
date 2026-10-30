import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../config/app_config.dart';
import 'cache_config.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// API client. [store] holds the cached GET responses.
Dio buildDio(AppConfig config, CacheStore store) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }
  // Order matters: the TTL header must exist before the cache stores the
  // response, and the cache must see errors before `ErrorInterceptor` rejects
  // them (otherwise no stale fallback while offline).
  dio.interceptors.add(CacheTtlInterceptor());
  dio.interceptors.add(DioCacheInterceptor(options: buildCacheOptions(store)));
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}

/// Client for downloading mod files from absolute URLs: no baseUrl, no cache,
/// and a long receive timeout so a large file is not killed midway.
Dio buildDownloadDio(AppConfig config) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(minutes: 2),
    ),
  );
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
