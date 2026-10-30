import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/download_manager.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_state.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements DownloadRepository {}

const record = ModDownloadRecord(
  sourceId: 7,
  title: 'Seven',
  type: ModType.bus,
  relPath: 'mods/7.zip',
  sizeBytes: 100,
  createdAtMs: 1,
);
const mod = ModDetail(sourceId: 7, type: ModType.bus, title: 'Seven');

void main() {
  late _MockRepo repo;
  late DownloadManager manager;
  ModDownloadCubit cubit() => ModDownloadCubit(repo, manager);

  setUpAll(() {
    registerFallbackValue(mod);
    registerFallbackValue(record);
  });
  setUp(() {
    repo = _MockRepo();
    manager = DownloadManager(repo);
    // A failed download looks up the previous copy: default = none.
    when(() => repo.find(any())).thenAnswer((_) async => right(null));
  });

  void stubFind(Either<Failure, ModDownloadRecord?> r) =>
      when(() => repo.find(7)).thenAnswer((_) async => r);
  void stubExists(Either<Failure, bool> r) =>
      when(() => repo.fileExists(any())).thenAnswer((_) async => r);

  /// Stubs download so the test drives progress and completion by hand.
  Completer<Either<Failure, ModDownloadRecord>> stubDownload() {
    final done = Completer<Either<Failure, ModDownloadRecord>>();
    when(
      () => repo.download(
        any(),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) => done.future);
    return done;
  }

  void Function(int, int) progress() =>
      verify(
            () => repo.download(
              any(),
              onProgress: captureAny(named: 'onProgress'),
              cancelToken: any(named: 'cancelToken'),
            ),
          ).captured.single
          as void Function(int, int);

  CancelToken token() =>
      verify(
            () => repo.download(
              any(),
              onProgress: any(named: 'onProgress'),
              cancelToken: captureAny(named: 'cancelToken'),
            ),
          ).captured.last
          as CancelToken;

  test('initial state is checking, not idle', () {
    expect(cubit().state, const ModDownloadState.checking());
  });

  group('check', () {
    blocTest<ModDownloadCubit, ModDownloadState>(
      'record + file -> downloaded',
      setUp: () {
        stubFind(right(record));
        stubExists(right(true));
      },
      build: cubit,
      act: (c) => c.check(7),
      expect: () => [const ModDownloadState.downloaded(record)],
    );
    blocTest<ModDownloadCubit, ModDownloadState>(
      'record without file -> fileMissing',
      setUp: () {
        stubFind(right(record));
        stubExists(right(false));
      },
      build: cubit,
      act: (c) => c.check(7),
      expect: () => [const ModDownloadState.fileMissing(record)],
    );
    blocTest<ModDownloadCubit, ModDownloadState>(
      'no record -> idle',
      setUp: () => stubFind(right(null)),
      build: cubit,
      act: (c) => c.check(7),
      expect: () => [const ModDownloadState.idle()],
      verify: (_) => verifyNever(() => repo.fileExists(any())),
    );
    blocTest<ModDownloadCubit, ModDownloadState>(
      'find Left -> checkFailure (not a download failure)',
      setUp: () => stubFind(left(const Failure.cache())),
      build: cubit,
      act: (c) => c.check(7),
      expect: () => [const ModDownloadState.checkFailure(Failure.cache())],
    );
    blocTest<ModDownloadCubit, ModDownloadState>(
      'fileExists Left -> checkFailure',
      setUp: () {
        stubFind(right(record));
        stubExists(left(const Failure.cache()));
      },
      build: cubit,
      act: (c) => c.check(7),
      expect: () => [const ModDownloadState.checkFailure(Failure.cache())],
    );

    test('retry from checkFailure goes through checking again', () async {
      stubFind(left(const Failure.cache()));
      final c = cubit();
      await c.check(7);
      final states = <ModDownloadState>[];
      c.stream.listen(states.add);
      stubFind(right(null));
      await c.check(7);
      await pumpEventQueue();
      expect(states, [
        const ModDownloadState.checking(),
        const ModDownloadState.idle(),
      ]);
      verifyNever(
        () => repo.download(
          any(),
          onProgress: any(named: 'onProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      );
      await c.close();
    });

    test('check consults the manager first: shows the live transfer', () async {
      stubDownload();
      unawaited(manager.start(mod));
      progress()(5, 10);
      final c = cubit();
      await c.check(7);
      expect(
        c.state,
        const ModDownloadState.downloading(received: 5, total: 10),
      );
      verifyNever(() => repo.find(any()));
      await c.close();
    });
  });

  group('start', () {
    test('progress flows from the manager, then downloaded', () async {
      final done = stubDownload();
      final c = cubit();
      final states = <ModDownloadState>[];
      c.stream.listen(states.add);

      unawaited(c.start(mod));
      final onProgress = progress();
      onProgress(10, 1000);
      onProgress(1000, 1000);
      done.complete(right(record));
      await pumpEventQueue();

      expect(states, [
        const ModDownloadState.downloading(received: 0, total: -1),
        const ModDownloadState.downloading(received: 10, total: 1000),
        const ModDownloadState.downloading(received: 1000, total: 1000),
        const ModDownloadState.downloaded(record),
      ]);
      await c.close();
    });

    blocTest<ModDownloadCubit, ModDownloadState>(
      'failure -> failure state',
      setUp: () => when(
        () => repo.download(
          any(),
          onProgress: any(named: 'onProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => left(const Failure.network())),
      build: cubit,
      act: (c) => c.start(mod),
      expect: () => [
        const ModDownloadState.downloading(received: 0, total: -1),
        const ModDownloadState.failure(Failure.network()),
      ],
    );

    test('explicit cancel -> token cancelled, re-resolves to idle', () async {
      final done = stubDownload();
      stubFind(right(null));
      final c = cubit();
      final states = <ModDownloadState>[];
      c.stream.listen(states.add);

      unawaited(c.start(mod));
      final t = token();
      c.cancel();
      expect(t.isCancelled, isTrue);
      done.complete(left(const Failure.network()));
      await pumpEventQueue();

      expect(states, [
        const ModDownloadState.downloading(received: 0, total: -1),
        const ModDownloadState.idle(),
      ]);
      await c.close();
    });

    test('cancel of a re-download falls back to the previous copy', () async {
      final done = stubDownload();
      stubFind(right(record));
      stubExists(right(true));
      final c = cubit();
      unawaited(c.start(mod));
      c.cancel();
      done.complete(left(const Failure.network()));
      await pumpEventQueue();
      expect(c.state, const ModDownloadState.downloaded(record));
      await c.close();
    });

    test('two cubits starting the same id: one transfer', () async {
      final done = stubDownload();
      final a = cubit();
      final b = cubit();
      unawaited(a.start(mod));
      unawaited(b.start(mod));
      done.complete(right(record));
      await pumpEventQueue();

      verify(
        () => repo.download(
          any(),
          onProgress: any(named: 'onProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
      expect(a.state, const ModDownloadState.downloaded(record));
      expect(b.state, const ModDownloadState.downloaded(record));
      await a.close();
      await b.close();
    });

    test('restart after failure works', () async {
      var first = true;
      when(
        () => repo.download(
          any(),
          onProgress: any(named: 'onProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async {
        if (first) {
          first = false;
          return left(const Failure.network());
        }
        return right(record);
      });
      final c = cubit();
      await c.start(mod);
      expect(c.state, const ModDownloadState.failure(Failure.network()));
      await c.start(mod);
      expect(c.state, const ModDownloadState.downloaded(record));
      await c.close();
    });

    test(
      'cancel then restart: a later failure is a failure, not idle',
      () async {
        final first = stubDownload();
        stubFind(right(null));
        final c = cubit();
        unawaited(c.start(mod));
        c.cancel();
        first.complete(left(const Failure.network()));
        await pumpEventQueue();
        expect(c.state, const ModDownloadState.idle());

        when(
          () => repo.download(
            any(),
            onProgress: any(named: 'onProgress'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => left(const Failure.network()));
        await c.start(mod);
        expect(c.state, const ModDownloadState.failure(Failure.network()));
        await c.close();
      },
    );

    test('close does NOT cancel; a new cubit picks the transfer up', () async {
      final done = stubDownload();
      final c = cubit();
      final states = <ModDownloadState>[];
      c.stream.listen(states.add);

      unawaited(c.start(mod));
      final args = verify(
        () => repo.download(
          any(),
          onProgress: captureAny(named: 'onProgress'),
          cancelToken: captureAny(named: 'cancelToken'),
        ),
      ).captured;
      final onProgress = args[0] as void Function(int, int);
      final t = args[1] as CancelToken;
      await c.close();
      expect(t.isCancelled, isFalse);

      onProgress(50, 100); // no emit on the closed cubit
      expect(states, [
        const ModDownloadState.downloading(received: 0, total: -1),
      ]);

      final reopened = cubit();
      await reopened.check(7);
      expect(
        reopened.state,
        const ModDownloadState.downloading(received: 50, total: 100),
      );
      done.complete(right(record));
      await pumpEventQueue();
      expect(reopened.state, const ModDownloadState.downloaded(record));
      await reopened.close();
    });
  });

  test('importToGame delegates and returns the outcome', () async {
    when(
      () => repo.importToGame(record),
    ).thenAnswer((_) async => right(ImportOutcome.notInstalled));
    final c = cubit();

    expect(await c.importToGame(record), right(ImportOutcome.notInstalled));
    expect(c.state, const ModDownloadState.checking());
    await c.close();
  });
}
