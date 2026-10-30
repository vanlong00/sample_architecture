import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Downloads a mod file from an absolute URL straight to disk. Uses the
/// `@Named('download')` Dio (no baseUrl/cache, long receive timeout).
///
/// Throws [DioException]; `ErrorInterceptor` has already attached the app
/// exception to `.error` so `guard()` can map it.
@lazySingleton
class DownloadRemoteDataSource {
  DownloadRemoteDataSource(@Named('download') this._dio);

  final Dio _dio;

  /// `total == -1` in [onProgress] means the server sent no Content-Length.
  Future<void> download({
    required String url,
    required String savePath,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );
  }
}
