import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'data_version_model.dart';

part 'data_version_remote_datasource.g.dart';

/// Lives in `core/` because it controls the HTTP cache of every feature (see
/// `CacheSyncService`). Throws `DioException` like every data source.
@RestApi()
@lazySingleton
abstract class DataVersionRemoteDataSource {
  @factoryMethod
  factory DataVersionRemoteDataSource(Dio dio) = _DataVersionRemoteDataSource;

  /// [options] must be `forceRefreshOptions()`, or this endpoint would lock
  /// itself in the cache for `kCacheTtl` and never trigger a clear.
  @GET('/data-version')
  Future<DataVersionModel> getVersion({@DioOptions() Options? options});
}
