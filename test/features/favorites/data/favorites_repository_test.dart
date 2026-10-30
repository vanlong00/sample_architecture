import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/data/repositories/favorites_repository.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocal extends Mock implements FavoritesLocalDataSource {}

FavoriteRecord rec(int id, int at) => FavoriteRecord(
  sourceId: id,
  title: 'Mod $id',
  type: ModType.car,
  savedAtMs: at,
);

void main() {
  late _MockLocal local;
  late FavoritesRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(rec(0, 0)));
  setUp(() {
    local = _MockLocal();
    repo = FavoritesRepositoryImpl(local);
  });

  test('list is newest first', () async {
    when(
      () => local.readAll(),
    ).thenReturn([rec(1, 10), rec(2, 30), rec(3, 20)]);
    final r = await repo.list();
    expect(r.getOrElse((_) => []).map((e) => e.sourceId), [2, 3, 1]);
  });

  test('add and remove delegate and return unit', () async {
    when(() => local.write(any())).thenAnswer((_) async {});
    when(() => local.delete(any())).thenAnswer((_) async {});
    expect(await repo.add(rec(1, 1)), right<Failure, Unit>(unit));
    expect(await repo.remove(1), right<Failure, Unit>(unit));
    verify(() => local.write(rec(1, 1))).called(1);
    verify(() => local.delete(1)).called(1);
  });

  test('CacheException maps to Left(cache)', () async {
    when(() => local.readAll()).thenThrow(CacheException());
    when(() => local.write(any())).thenThrow(CacheException());
    when(() => local.delete(any())).thenThrow(CacheException());
    const failure = Failure.cache();
    expect(await repo.list(), left<Failure, List<FavoriteRecord>>(failure));
    expect(await repo.add(rec(1, 1)), left<Failure, Unit>(failure));
    expect(await repo.remove(1), left<Failure, Unit>(failure));
  });
}
