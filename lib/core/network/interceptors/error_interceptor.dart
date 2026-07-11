import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final Object mapped;
    if (status == null) {
      mapped = NetworkException();
    } else if (status == 401) {
      mapped = UnauthorizedException();
    } else {
      mapped = ServerException(
        message: err.response?.statusMessage,
        code: status,
      );
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
      ),
    );
  }
}
