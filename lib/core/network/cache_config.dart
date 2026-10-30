import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// TTL for every GET response. One number, no per-endpoint table: callers that
/// need fresh data use [forceRefreshOptions].
const Duration kCacheTtl = Duration(days: 3);

/// How long a stale copy stays on disk after [kCacheTtl] (offline fallback).
/// Must be larger than [kCacheTtl].
const Duration kCacheMaxStale = Duration(days: 7);

/// Sets `cache-control` on GET responses before `DioCacheInterceptor` stores
/// them, because the backend sends no freshness headers.
class CacheTtlInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.method.toUpperCase() == 'GET') {
      response.headers.set('cache-control', 'max-age=${kCacheTtl.inSeconds}');
    }
    handler.next(response);
  }
}

/// Status codes that may fall back to a stale copy. Allow list: 401/403/404
/// must surface as real errors.
const List<int> kHitCacheOnErrorCodes = [408, 429, 500, 502, 503, 504];

CacheOptions buildCacheOptions(CacheStore store) => CacheOptions(
  store: store,
  policy: CachePolicy.request,
  maxStale: kCacheMaxStale,
  hitCacheOnErrorCodes: kHitCacheOnErrorCodes,
  hitCacheOnNetworkFailure: true,
);

/// Skips the cache read, then stores the new response (pull to refresh).
Options forceRefreshOptions() => const CacheOptions(
  store: null,
  policy: CachePolicy.refresh,
  maxStale: kCacheMaxStale,
  hitCacheOnErrorCodes: kHitCacheOnErrorCodes,
  hitCacheOnNetworkFailure: true,
).toOptions();
