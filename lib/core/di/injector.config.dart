// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sample_architecture/core/config/app_config.dart' as _i776;
import 'package:sample_architecture/core/di/injector.dart' as _i1043;
import 'package:sample_architecture/core/storage/hive_service.dart' as _i4;
import 'package:sample_architecture/core/storage/secure_storage_service.dart'
    as _i983;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i4.HiveService>(() => registerModule.hiveService);
    gh.lazySingleton<_i983.SecureStorageService>(
      () =>
          registerModule.secureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i776.AppConfig>(),
        gh<_i983.SecureStorageService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i1043.RegisterModule {}
