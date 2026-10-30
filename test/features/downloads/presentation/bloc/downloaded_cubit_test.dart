import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_state.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements DownloadRepository {}

ModDownloadRecord rec(int id, {int at = 1, int size = 10}) => ModDownloadRecord(
  sourceId: id,
  title: 'Mod $id',
  type: ModType.bus,
  relPath: 'mods/$id.zip',
  sizeBytes: size,
  createdAtMs: at,
);

void main() {
  late _MockRepo repo;
  late StreamController<void> changes;

  setUpAll(() => registerFallbackValue(rec(0)));
  setUp(() {
    repo = _MockRepo();
    changes = StreamController<void>.broadcast();
    when(() => repo.changes).thenAnswer((_) => changes.stream);
  });
  tearDown(() => changes.close());

  blocTest<DownloadedCubit, DownloadedState>(
    'load: loading then success (list order kept), totalBytes summed',
    setUp: () => when(() => repo.list()).thenAnswer(
      (_) async => right([rec(2, at: 3, size: 7), rec(1, at: 1, size: 5)]),
    ),
    build: () => DownloadedCubit(repo),
    act: (c) => c.load(),
    expect: () => [
      const DownloadedState.loading(),
      DownloadedState.success(
        records: [rec(2, at: 3, size: 7), rec(1, at: 1, size: 5)],
        totalBytes: 12,
      ),
    ],
  );

  blocTest<DownloadedCubit, DownloadedState>(
    'load failure',
    setUp: () => when(
      () => repo.list(),
    ).thenAnswer((_) async => left(const Failure.cache())),
    build: () => DownloadedCubit(repo),
    act: (c) => c.load(),
    expect: () => [
      const DownloadedState.loading(),
      const DownloadedState.failure(Failure.cache()),
    ],
  );

  blocTest<DownloadedCubit, DownloadedState>(
    'delete -> repo.delete then refresh',
    setUp: () {
      when(() => repo.delete(any())).thenAnswer((_) async => right(unit));
      when(() => repo.list()).thenAnswer((_) async => right([rec(2)]));
    },
    build: () => DownloadedCubit(repo),
    act: (c) => c.delete(rec(1)),
    expect: () => [
      DownloadedState.success(records: [rec(2)], totalBytes: 10),
    ],
    verify: (_) {
      verify(() => repo.delete(rec(1))).called(1);
      verify(() => repo.list()).called(1);
    },
  );

  test('delete failure is returned; the list stays', () async {
    when(
      () => repo.delete(any()),
    ).thenAnswer((_) async => left(const Failure.cache()));
    when(() => repo.list()).thenAnswer((_) async => right([rec(1)]));
    final c = DownloadedCubit(repo);
    await c.load();
    final shown = c.state;
    final states = <DownloadedState>[];
    c.stream.listen(states.add);

    expect(await c.delete(rec(1)), left(const Failure.cache()));
    await pumpEventQueue();

    expect(states, isEmpty);
    expect(c.state, shown);
    await c.close();
  });

  test(
    'delete waits for the newest refresh when its own is superseded',
    () async {
      final g1 = Completer<Either<Failure, List<ModDownloadRecord>>>();
      final g2 = Completer<Either<Failure, List<ModDownloadRecord>>>();
      when(() => repo.delete(any())).thenAnswer((_) async => right(unit));
      var calls = 0;
      when(
        () => repo.list(),
      ).thenAnswer((_) => ++calls == 1 ? g1.future : g2.future);
      final c = DownloadedCubit(repo);

      var done = false;
      final f = c.delete(rec(1)).then((_) => done = true);
      await pumpEventQueue();
      changes.add(null); // a newer refresh supersedes delete's own
      await pumpEventQueue();

      g1.complete(right([rec(9)])); // stale: must be dropped
      await pumpEventQueue();
      expect(done, isFalse);
      expect(c.state, const DownloadedState.initial());

      g2.complete(right([rec(2)]));
      await f;
      expect(
        c.state,
        DownloadedState.success(records: [rec(2)], totalBytes: 10),
      );
      await c.close();
    },
  );

  test('markMissing flags the record; a new record clears the flag', () async {
    when(() => repo.list()).thenAnswer((_) async => right([rec(1)]));
    final c = DownloadedCubit(repo);
    await c.load();
    await c.markMissing(rec(1));
    expect((c.state as DownloadedSuccess).missingIds, {1});

    when(() => repo.list()).thenAnswer((_) async => right([rec(1, at: 5)]));
    changes.add(null);
    await pumpEventQueue();
    expect((c.state as DownloadedSuccess).missingIds, isEmpty);
    await c.close();
  });

  blocTest<DownloadedCubit, DownloadedState>(
    'changes event triggers a silent refresh (no loading)',
    setUp: () =>
        when(() => repo.list()).thenAnswer((_) async => right([rec(1)])),
    build: () => DownloadedCubit(repo),
    act: (c) async {
      changes.add(null);
      await pumpEventQueue();
    },
    expect: () => [
      DownloadedState.success(records: [rec(1)], totalBytes: 10),
    ],
  );

  test('close cancels the changes subscription', () async {
    when(() => repo.list()).thenAnswer((_) async => right([rec(1)]));
    final c = DownloadedCubit(repo);
    expect(changes.hasListener, isTrue);
    await c.close();
    expect(changes.hasListener, isFalse);
    changes.add(null);
    await pumpEventQueue();
    verifyNever(() => repo.list());
  });

  test('importToGame delegates', () async {
    when(
      () => repo.importToGame(any()),
    ).thenAnswer((_) async => right(ImportOutcome.sent));
    final c = DownloadedCubit(repo);
    expect(await c.importToGame(rec(1)), right(ImportOutcome.sent));
    await c.close();
  });
}
