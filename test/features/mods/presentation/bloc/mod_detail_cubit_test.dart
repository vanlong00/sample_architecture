import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

const mod = ModDetail(sourceId: 1, type: ModType.bus, title: 't');
const rel = ModCard(sourceId: 2, type: ModType.bus, title: 'r');
const failure = Failure.network();

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  void stub(Either<Failure, ModDetail> d, Either<Failure, List<ModCard>> r) {
    when(() => repo.detail(1)).thenAnswer((_) async => d);
    when(() => repo.related(1)).thenAnswer((_) async => r);
  }

  blocTest<ModDetailCubit, ModDetailState>(
    'success with related',
    setUp: () => stub(right(mod), right([rel])),
    build: () => ModDetailCubit(repo),
    act: (c) => c.load(1),
    expect: () => [
      const ModDetailState.loading(),
      const ModDetailState.success(mod, [rel]),
    ],
  );

  blocTest<ModDetailCubit, ModDetailState>(
    'related failing yields empty related; both called',
    setUp: () => stub(right(mod), left(failure)),
    build: () => ModDetailCubit(repo),
    act: (c) => c.load(1),
    expect: () => [
      const ModDetailState.loading(),
      const ModDetailState.success(mod, []),
    ],
    verify: (_) {
      verify(() => repo.detail(1)).called(1);
      verify(() => repo.related(1)).called(1);
    },
  );

  blocTest<ModDetailCubit, ModDetailState>(
    'detail failure -> failure state',
    setUp: () => stub(left(failure), right([rel])),
    build: () => ModDetailCubit(repo),
    act: (c) => c.load(1),
    expect: () => [
      const ModDetailState.loading(),
      const ModDetailState.failure(failure),
    ],
  );
}
