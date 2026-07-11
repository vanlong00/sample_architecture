import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/network/interceptors/error_interceptor.dart';

class _CaptureHandler extends ErrorInterceptorHandler {
  Object? captured;
  @override
  void reject(DioException error, [bool callFollowingErrorInterceptor = false]) {
    captured = error.error;
  }
}

void main() {
  final requestOptions = RequestOptions(path: '/x');

  DioException dioErr(int? status) => DioException(
        requestOptions: requestOptions,
        response: status == null
            ? null
            : Response<dynamic>(requestOptions: requestOptions, statusCode: status),
        type: status == null
            ? DioExceptionType.connectionError
            : DioExceptionType.badResponse,
      );

  test('401 → UnauthorizedException', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(401), handler);
    expect(handler.captured, isA<UnauthorizedException>());
  });

  test('500 → ServerException với code', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(500), handler);
    expect(handler.captured, isA<ServerException>());
    expect((handler.captured as ServerException).code, 500);
  });

  test('không có response (mất mạng) → NetworkException', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(null), handler);
    expect(handler.captured, isA<NetworkException>());
  });
}
