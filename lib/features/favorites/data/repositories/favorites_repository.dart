import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/favorite_record.dart';

abstract class FavoritesRepository {
  /// Newest saved first.
  Future<Either<Failure, List<FavoriteRecord>>> list();
  Future<Either<Failure, Unit>> add(FavoriteRecord record);
  Future<Either<Failure, Unit>> remove(int sourceId);
}

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._local);

  final FavoritesLocalDataSource _local;

  @override
  Future<Either<Failure, List<FavoriteRecord>>> list() => guard(() async {
    final items = _local.readAll()
      ..sort((a, b) => b.savedAtMs.compareTo(a.savedAtMs));
    return items;
  });

  @override
  Future<Either<Failure, Unit>> add(FavoriteRecord record) => guard(() async {
    await _local.write(record);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> remove(int sourceId) => guard(() async {
    await _local.delete(sourceId);
    return unit;
  });
}
