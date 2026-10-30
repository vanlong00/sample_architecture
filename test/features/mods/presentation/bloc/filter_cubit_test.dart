import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/mods/data/models/filter_option.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/filter_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/filter_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  final FilterOptions options = (
    categories: [const FilterOption(id: 'c', name: 'Cat')],
    manufacturers: <FilterOption>[],
    countries: <FilterOption>[],
  );

  blocTest<FilterCubit, FilterState>(
    'load success',
    setUp: () => when(
      () => repo.filterOptions(ModType.bus),
    ).thenAnswer((_) async => right(options)),
    build: () => FilterCubit(repo),
    act: (c) => c.load(ModType.bus),
    expect: () => [const FilterState.loading(), FilterState.success(options)],
  );

  blocTest<FilterCubit, FilterState>(
    'load failure',
    setUp: () => when(
      () => repo.filterOptions(ModType.bus),
    ).thenAnswer((_) async => left(const Failure.network())),
    build: () => FilterCubit(repo),
    act: (c) => c.load(ModType.bus),
    expect: () => [
      const FilterState.loading(),
      const FilterState.failure(Failure.network()),
    ],
  );
}
