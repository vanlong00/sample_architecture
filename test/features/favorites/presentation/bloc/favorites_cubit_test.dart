import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/data/repositories/favorites_repository.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

FavoriteRecord rec(int id, [int at = 1]) => FavoriteRecord(
  sourceId: id,
  title: 'Mod $id',
  type: ModType.bus,
  savedAtMs: at,
);

void main() {
  late _MockRepo repo;
  late ModDetail mod;

  setUpAll(() => registerFallbackValue(rec(0)));
  setUp(() {
    repo = _MockRepo();
    mod = const ModDetail(
      sourceId: 5,
      type: ModType.truck,
      title: 'Five',
      media: ModMedia(thumbnail: 'http://t/5.png'),
    );
    when(() => repo.add(any())).thenAnswer((_) async => right(unit));
    when(() => repo.remove(any())).thenAnswer((_) async => right(unit));
  });

  blocTest<FavoritesCubit, FavoritesState>(
    'load emits loading then success',
    setUp: () =>
        when(() => repo.list()).thenAnswer((_) async => right([rec(1)])),
    build: () => FavoritesCubit(repo),
    act: (c) => c.load(),
    expect: () => [
      const FavoritesState.loading(),
      FavoritesState.success([rec(1)]),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'load failure emits failure',
    setUp: () => when(
      () => repo.list(),
    ).thenAnswer((_) async => left(const Failure.cache())),
    build: () => FavoritesCubit(repo),
    act: (c) => c.load(),
    expect: () => [
      const FavoritesState.loading(),
      const FavoritesState.failure(Failure.cache()),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle adds a snapshot at the head',
    build: () => FavoritesCubit(repo),
    seed: () => FavoritesState.success([rec(1)]),
    act: (c) => c.toggle(mod),
    verify: (c) {
      final items = (c.state as FavoritesSuccess).items;
      expect(items.map((e) => e.sourceId), [5, 1]);
      expect(items.first.title, 'Five');
      expect(items.first.thumbUrl, 'http://t/5.png');
      expect(items.first.type, ModType.truck);
      expect(c.state.isFavorite(5), isTrue);
      verify(() => repo.add(items.first)).called(1);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle removes an existing favorite',
    build: () => FavoritesCubit(repo),
    seed: () => FavoritesState.success([rec(5), rec(1)]),
    act: (c) => c.toggle(mod),
    expect: () => [
      FavoritesState.success([rec(1)]),
    ],
    verify: (_) => verify(() => repo.remove(5)).called(1),
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'remove drops the item; unknown id emits nothing',
    build: () => FavoritesCubit(repo),
    seed: () => FavoritesState.success([rec(1), rec(2)]),
    act: (c) async {
      await c.remove(99);
      await c.remove(1);
    },
    expect: () => [
      FavoritesState.success([rec(2)]),
    ],
    verify: (_) {
      verify(() => repo.remove(1)).called(1);
      verifyNever(() => repo.remove(99));
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'repository failure on add emits failure',
    setUp: () => when(
      () => repo.add(any()),
    ).thenAnswer((_) async => left(const Failure.cache())),
    build: () => FavoritesCubit(repo),
    seed: () => const FavoritesState.success([]),
    act: (c) => c.toggle(mod),
    skip: 1,
    expect: () => [const FavoritesState.failure(Failure.cache())],
  );

  test('isFavorite is false outside success', () {
    expect(const FavoritesState.initial().isFavorite(1), isFalse);
    expect(const FavoritesState.loading().isFavorite(1), isFalse);
    expect(FavoritesState.success([rec(1)]).isFavorite(1), isTrue);
    expect(FavoritesState.success([rec(1)]).isFavorite(2), isFalse);
  });
}
