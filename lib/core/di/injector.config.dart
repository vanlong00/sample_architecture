// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:busmod/core/ads/ad_network.dart' as _i1015;
import 'package:busmod/core/ads/ads_service.dart' as _i848;
import 'package:busmod/core/analytics/remote_config_service.dart' as _i843;
import 'package:busmod/core/config/app_config.dart' as _i510;
import 'package:busmod/core/di/injector.dart' as _i348;
import 'package:busmod/core/network/data_version_remote_datasource.dart'
    as _i926;
import 'package:busmod/core/router/app_router.dart' as _i465;
import 'package:busmod/core/services/cache_sync_service.dart' as _i632;
import 'package:busmod/core/storage/local_store.dart' as _i334;
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart'
    as _i869;
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart'
    as _i898;
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart'
    as _i746;
import 'package:busmod/features/downloads/data/repositories/download_repository.dart'
    as _i854;
import 'package:busmod/features/downloads/presentation/bloc/download_manager.dart'
    as _i93;
import 'package:busmod/features/downloads/presentation/bloc/downloaded_cubit.dart'
    as _i907;
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart'
    as _i386;
import 'package:busmod/features/favorites/data/datasources/favorites_local_datasource.dart'
    as _i276;
import 'package:busmod/features/favorites/data/repositories/favorites_repository.dart'
    as _i15;
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart'
    as _i211;
import 'package:busmod/features/mods/data/datasources/mods_remote_datasource.dart'
    as _i255;
import 'package:busmod/features/mods/data/models/mod_type.dart' as _i560;
import 'package:busmod/features/mods/data/repositories/mods_repository.dart'
    as _i94;
import 'package:busmod/features/mods/presentation/bloc/filter_cubit.dart'
    as _i437;
import 'package:busmod/features/mods/presentation/bloc/mod_detail_cubit.dart'
    as _i971;
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart'
    as _i604;
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart'
    as _i65;
import 'package:busmod/features/premium/data/subscription_service.dart'
    as _i911;
import 'package:busmod/features/premium/presentation/bloc/paywall_cubit.dart'
    as _i913;
import 'package:busmod/features/premium/presentation/bloc/pro_status_cubit.dart'
    as _i777;
import 'package:busmod/features/settings/presentation/bloc/locale_cubit.dart'
    as _i862;
import 'package:busmod/features/settings/presentation/bloc/theme_cubit.dart'
    as _i535;
import 'package:busmod/features/splash/presentation/bloc/splash_cubit.dart'
    as _i805;
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i843.RemoteConfigService>(
      () => _i843.RemoteConfigService(),
    );
    gh.lazySingleton<_i334.LocalStore>(() => registerModule.localStore);
    gh.lazySingleton<_i465.AppRouter>(() => _i465.AppRouter());
    gh.lazySingleton<_i746.PbsuLauncherDataSource>(
      () => _i746.PbsuLauncherDataSource(),
    );
    gh.factory<_i862.LocaleCubit>(
      () => _i862.LocaleCubit(gh<_i334.LocalStore>()),
    );
    gh.factory<_i535.ThemeCubit>(
      () => _i535.ThemeCubit(gh<_i334.LocalStore>()),
    );
    gh.lazySingleton<_i869.DownloadLocalDataSource>(
      () => _i869.DownloadLocalDataSource(gh<_i334.LocalStore>()),
    );
    gh.lazySingleton<_i276.FavoritesLocalDataSource>(
      () => _i276.FavoritesLocalDataSource(gh<_i334.LocalStore>()),
    );
    gh.lazySingleton<_i15.FavoritesRepository>(
      () => _i15.FavoritesRepositoryImpl(gh<_i276.FavoritesLocalDataSource>()),
    );
    gh.factory<_i211.FavoritesCubit>(
      () => _i211.FavoritesCubit(gh<_i15.FavoritesRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.downloadDio(gh<_i510.AppConfig>()),
      instanceName: 'download',
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i510.AppConfig>(), gh<_i695.CacheStore>()),
    );
    gh.lazySingleton<_i926.DataVersionRemoteDataSource>(
      () => _i926.DataVersionRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i255.ModsRemoteDataSource>(
      () => _i255.ModsRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i898.DownloadRemoteDataSource>(
      () => _i898.DownloadRemoteDataSource(
        gh<_i361.Dio>(instanceName: 'download'),
      ),
    );
    gh.lazySingleton<_i1015.AdCountryLookup>(
      () => _i1015.AdCountryLookup(
        gh<_i361.Dio>(instanceName: 'download'),
        gh<_i334.LocalStore>(),
      ),
    );
    gh.lazySingleton<_i94.ModsRepository>(
      () => _i94.ModsRepositoryImpl(gh<_i255.ModsRemoteDataSource>()),
    );
    gh.lazySingleton<_i854.DownloadRepository>(
      () => _i854.DownloadRepositoryImpl(
        gh<_i898.DownloadRemoteDataSource>(),
        gh<_i869.DownloadLocalDataSource>(),
        gh<_i746.PbsuLauncherDataSource>(),
      ),
    );
    gh.factoryParam<_i604.ModListCubit, _i560.ModType, dynamic>(
      (type, _) => _i604.ModListCubit(gh<_i94.ModsRepository>(), type),
    );
    gh.lazySingleton<_i632.CacheSyncService>(
      () => _i632.CacheSyncService(
        gh<_i926.DataVersionRemoteDataSource>(),
        gh<_i334.LocalStore>(),
        gh<_i695.CacheStore>(),
      ),
    );
    gh.lazySingleton<_i93.DownloadManager>(
      () => _i93.DownloadManager(gh<_i854.DownloadRepository>()),
    );
    gh.factory<_i907.DownloadedCubit>(
      () => _i907.DownloadedCubit(gh<_i854.DownloadRepository>()),
    );
    gh.lazySingleton<_i848.AdsService>(
      () => _i848.AdsService(
        gh<_i334.LocalStore>(),
        gh<_i843.RemoteConfigService>(),
        gh<_i1015.AdCountryLookup>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i386.ModDownloadCubit>(
      () => _i386.ModDownloadCubit(
        gh<_i854.DownloadRepository>(),
        gh<_i93.DownloadManager>(),
      ),
    );
    gh.factory<_i437.FilterCubit>(
      () => _i437.FilterCubit(gh<_i94.ModsRepository>()),
    );
    gh.factory<_i971.ModDetailCubit>(
      () => _i971.ModDetailCubit(gh<_i94.ModsRepository>()),
    );
    gh.factory<_i65.SearchBloc>(
      () => _i65.SearchBloc(gh<_i94.ModsRepository>()),
    );
    gh.lazySingleton<_i911.SubscriptionService>(
      () => _i911.SubscriptionService(gh<_i848.AdsService>()),
    );
    gh.factory<_i805.SplashCubit>(
      () => _i805.SplashCubit(
        gh<_i632.CacheSyncService>(),
        gh<_i848.AdsService>(),
        gh<_i911.SubscriptionService>(),
      ),
    );
    gh.factory<_i913.PaywallCubit>(
      () => _i913.PaywallCubit(gh<_i911.SubscriptionService>()),
    );
    gh.factory<_i777.ProStatusCubit>(
      () => _i777.ProStatusCubit(gh<_i911.SubscriptionService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i348.RegisterModule {}
