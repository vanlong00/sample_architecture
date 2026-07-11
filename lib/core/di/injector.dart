import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../config/env.dart';
import '../network/dio_client.dart';
import '../storage/hive_service.dart';
import '../storage/secure_storage_service.dart';
import 'injector.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(AppEnv env) async {
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnv(env));
  getIt.init();
  await getIt<HiveService>().init();
}

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  SecureStorageService secureStorageService(FlutterSecureStorage s) =>
      SecureStorageService(s);

  @lazySingleton
  HiveService get hiveService => HiveService();

  @lazySingleton
  Dio dio(AppConfig config, SecureStorageService storage) =>
      buildDio(config, storage);
}
