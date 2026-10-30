import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/analytics/telemetry.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/network/cache_config.dart';
import '../datasources/mods_remote_datasource.dart';
import '../models/filter_option.dart';
import '../models/mod_card.dart';
import '../models/mod_detail.dart';
import '../models/mod_query.dart';
import '../models/mod_type.dart';

/// [nextSkip] / [hasMore] come from the RAW page (before the F3 filter) so
/// paging never stalls when a page is partly hidden.
typedef ModPage = ({List<ModCard> items, int nextSkip, bool hasMore});

typedef FilterOptions = ({
  List<FilterOption> categories,
  List<FilterOption> manufacturers,
  List<FilterOption> countries,
});

abstract class ModsRepository {
  static const int pageSize = 20;

  /// [forceRefresh] skips the HTTP cache read (pull to refresh) and stores the
  /// fresh response.
  Future<Either<Failure, ModPage>> list(
    ModQuery query, {
    required int skip,
    bool forceRefresh = false,
  });

  Future<Either<Failure, ModPage>> search({
    required String query,
    ModType? type,
    required int skip,
    bool forceRefresh = false,
  });

  Future<Either<Failure, ModDetail>> detail(int sourceId);

  Future<Either<Failure, List<ModCard>>> related(int sourceId);

  Future<Either<Failure, FilterOptions>> filterOptions(ModType type);
}

@LazySingleton(as: ModsRepository)
class ModsRepositoryImpl implements ModsRepository {
  ModsRepositoryImpl(this._remote);

  final ModsRemoteDataSource _remote;

  static const _limit = ModsRepository.pageSize;

  @override
  Future<Either<Failure, ModPage>> list(
    ModQuery query, {
    required int skip,
    bool forceRefresh = false,
  }) => guard(() async {
    final raw = await _remote.getMods(
      type: query.type.apiValue,
      category: query.filter.categoryId,
      manufacturer: query.filter.manufacturerId,
      country: query.filter.countryId,
      sort: query.sort.apiValue,
      skip: skip,
      limit: _limit,
      options: forceRefresh ? forceRefreshOptions() : null,
    );
    return _page(raw, skip);
  });

  @override
  Future<Either<Failure, ModPage>> search({
    required String query,
    ModType? type,
    required int skip,
    bool forceRefresh = false,
  }) => guard(() async {
    final raw = await _remote.search(
      q: query,
      type: type?.apiValue,
      skip: skip,
      limit: _limit,
      options: forceRefresh ? forceRefreshOptions() : null,
    );
    return _page(raw, skip);
  });

  @override
  Future<Either<Failure, ModDetail>> detail(int sourceId) => guard(() async {
    final mod = await _remote.getMod(sourceId);
    // F3: a not-mirrored mod must look like it does not exist.
    if (!mod.isDownloadable) throw ServerException(code: 404);
    return mod;
  });

  @override
  Future<Either<Failure, List<ModCard>>> related(int sourceId) => guard(
    () async => _visible(_parse(_asList(await _remote.getRelated(sourceId)))),
  );

  @override
  Future<Either<Failure, FilterOptions>> filterOptions(ModType type) =>
      guard(() async {
        final t = type.apiValue;
        final r = await Future.wait([
          _remote.getCategories(t),
          _remote.getManufacturers(t),
          _remote.getCountries(t),
        ]);
        return (categories: r[0], manufacturers: r[1], countries: r[2]);
      });

  /// Paging comes from the RAW page length, even when cards are skipped.
  ModPage _page(dynamic body, int skip) {
    final raw = _asList(body);
    return (
      items: _visible(_parse(raw)),
      nextSkip: skip + raw.length,
      hasMore: raw.length >= _limit,
    );
  }

  /// Boundary check: the body must be a JSON array.
  List<dynamic> _asList(dynamic body) => body is List
      ? body
      : throw ServerException(message: 'unexpected response shape');

  /// Parses each card on its own: a bad one (unknown `type`, wrong shape) is
  /// skipped and reported, the rest of the page survives.
  List<ModCard> _parse(List<dynamic> raw) {
    final cards = <ModCard>[];
    for (final item in raw) {
      try {
        cards.add(ModCard.fromJson(item as Map<String, dynamic>));
      } catch (e, st) {
        recordError(e, st, reason: 'skipped unparsable mod card');
      }
    }
    return cards;
  }

  // F3 app-side guard.
  List<ModCard> _visible(List<ModCard> cards) =>
      cards.where((c) => c.isDownloadable).toList();
}
