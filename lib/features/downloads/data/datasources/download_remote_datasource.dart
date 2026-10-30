import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../logic/mod_file.dart';

/// Downloads a mod file from an absolute URL straight to disk. Uses the
/// `@Named('download')` Dio (no baseUrl/cache, long receive timeout).
///
/// Redirects are followed here, not by Dio: at most [maxRedirects] hops, each
/// target checked with [isAllowedStorageUrl] BEFORE any request to it (F1), so
/// a CDN 3xx can never lead the app to a blocked or non-http(s) host.
///
/// Throws [DioException] (`ErrorInterceptor` has already attached the app
/// exception to `.error` so `guard()` can map it) or [ServerException] when a
/// redirect is refused.
@lazySingleton
class DownloadRemoteDataSource {
  DownloadRemoteDataSource(@Named('download') this._dio);

  final Dio _dio;

  static const maxRedirects = 3;
  static const _redirectCodes = {301, 302, 303, 307, 308};

  /// `total == -1` in [onProgress] means the server sent no Content-Length.
  Future<void> download({
    required String url,
    required String savePath,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    var current = Uri.parse(url);
    for (var followed = 0; ; followed++) {
      final res = await _dio.downloadUri(
        current,
        savePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
        // 3xx is not an error here: it is inspected below (the shared Dio only
        // accepts 2xx). Its body lands in savePath and is overwritten by the
        // next hop or deleted on failure.
        options: Options(
          followRedirects: false,
          validateStatus: (s) => s != null && s >= 200 && s < 400,
        ),
      );
      final status = res.statusCode ?? 0;
      if (status < 300) return;
      final next = _redirectTarget(
        current,
        status,
        res.headers.value('location'),
      );
      if (next == null || followed >= maxRedirects) {
        throw ServerException(message: 'redirect refused', code: 404);
      }
      current = next;
    }
  }

  /// Resolved, allowed target of a redirect, or `null` when it must be refused.
  static Uri? _redirectTarget(Uri from, int status, String? location) {
    if (!_redirectCodes.contains(status) || location == null) return null;
    try {
      final next = from.resolve(location);
      return isAllowedStorageUrl(next.toString()) ? next : null;
    } on FormatException {
      return null;
    }
  }
}
