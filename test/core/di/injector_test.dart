import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/network/data_version_remote_datasource.dart';
import 'package:busmod/core/services/cache_sync_service.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/settings/presentation/bloc/locale_cubit.dart';
import 'package:busmod/features/settings/presentation/bloc/theme_cubit.dart';

import '../../helpers/di_test_setup.dart';

void main() {
  late Directory dir;

  setUp(() async => dir = await setUpDi());
  tearDown(() => tearDownDi(dir));

  test('configureDependencies wires the DI graph', () {
    expect(getIt<AppConfig>().env, AppEnv.dev);
    expect(getIt<Dio>(), isA<Dio>());
    expect(getIt<Dio>(instanceName: 'download'), isNot(same(getIt<Dio>())));
    expect(getIt<DataVersionRemoteDataSource>(), isNotNull);
    expect(getIt<CacheSyncService>(), isNotNull);
    expect(getIt<ThemeCubit>(), isNotNull);
    expect(getIt<LocaleCubit>(), isNotNull);
    expect(getIt<LocalStore>().directory, dir.path);
  });
}
