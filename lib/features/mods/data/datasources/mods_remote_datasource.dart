import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/filter_option.dart';
import '../models/mod_detail.dart';

part 'mods_remote_datasource.g.dart';

/// Card lists come back RAW (a JSON array, `dynamic`): the repository parses each
/// card on its own so one bad card cannot fail the whole page.
///
/// Public read-only API (spec 5.3). Throws `DioException` like every data
/// source. `type` / `sort` are the server strings (`ModType.apiValue`,
/// `ModSort.apiValue`). [options] is `forceRefreshOptions()` for pull to
/// refresh (skips the cache read), null otherwise.
@RestApi()
@lazySingleton
abstract class ModsRemoteDataSource {
  @factoryMethod
  factory ModsRemoteDataSource(Dio dio) = _ModsRemoteDataSource;

  @GET('/mods')
  Future<dynamic> getMods({
    @Query('type') required String type,
    @Query('category') String? category,
    @Query('manufacturer') String? manufacturer,
    @Query('country') String? country,
    @Query('sort') required String sort,
    @Query('skip') required int skip,
    @Query('limit') required int limit,
    @DioOptions() Options? options,
  });

  @GET('/mods/search')
  Future<dynamic> search({
    @Query('q') required String q,
    @Query('type') String? type,
    @Query('skip') required int skip,
    @Query('limit') required int limit,
    @DioOptions() Options? options,
  });

  @GET('/mods/{sourceId}')
  Future<ModDetail> getMod(@Path('sourceId') int sourceId);

  @GET('/mods/{sourceId}/related')
  Future<dynamic> getRelated(
    @Path('sourceId') int sourceId, {
    @Query('limit') int limit = 8,
  });

  @GET('/categories')
  Future<List<FilterOption>> getCategories(@Query('type') String type);

  @GET('/manufacturers')
  Future<List<FilterOption>> getManufacturers(@Query('type') String type);

  @GET('/countries')
  Future<List<FilterOption>> getCountries(@Query('type') String type);
}
