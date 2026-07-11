import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

Dio buildDio(AppConfig config, SecureStorageService storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(AuthInterceptor(storage));
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
