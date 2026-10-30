import 'dart:async';

import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/download_manager.dart';
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
  late Completer<Either<Failure, ModDownloadRecord>> done;
  late void Function(int, int) onProgress;
  late CancelToken token;
  var calls = 0;

  setUpAll(() {
    registerFallbackValue(mod);
    registerFallbackValue(record);
  });
  setUp(() {
    repo = _MockRepo();
    manager = DownloadManager(repo);
    done = Completer();
    calls = 0;
    when(() => repo.find(any())).thenAnswer((_) async => right(null));
    when(
      () => repo.download(
        any(),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((i) {
      calls++;
      onProgress = i.namedArguments[#onProgress] as void Function(int, int);
      token = i.namedArguments[#cancelToken] as CancelToken;
      return done.future;
    });
  });

  void stubPrevious(ModDownloadRecord? rec, {bool fileExists = true}) {
    when(() => repo.find(7)).thenAnswer((_) async => right(rec));
    when(
      () => repo.fileExists(any()),
    ).thenAnswer((_) async => right(fileExists));
  }

  test('second start for the same id is one transfer', () async {
    final a = manager.start(mod);
    final b = manager.start(mod);
    expect(calls, 1);
    expect(identical(a, b), isTrue);
    done.complete(right(record));
    await a;
    expect(manager.current(7), isNull);
  });

  test('other ids download independently', () async {
    unawaited(manager.start(mod));
    unawaited(
      manager.start(
        const ModDetail(sourceId: 8, type: ModType.bus, title: 'x'),
      ),
    );
    expect(calls, 2);
    expect(manager.current(7), isNotNull);
    expect(manager.current(8), isNotNull);
    done.complete(right(record));
    await pumpEventQueue();
  });

  test('current() tracks live progress; throttled by percent', () async {
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    onProgress(10, 1000);
    onProgress(15, 1000); // same 1%
    onProgress(20, 1000);
    expect(
      manager.current(7),
      const ModDownloadState.downloading(received: 20, total: 1000),
    );
    done.complete(right(record));
    await f;
    expect(states, [
      const ModDownloadState.downloading(received: 0, total: -1),
      const ModDownloadState.downloading(received: 10, total: 1000),
      const ModDownloadState.downloading(received: 20, total: 1000),
      const ModDownloadState.downloaded(record),
    ]);
  });

  test('unknown total emits once', () async {
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    onProgress(10, -1);
    onProgress(20, -1);
    done.complete(right(record));
    await f;
    expect(states, [
      const ModDownloadState.downloading(received: 0, total: -1),
      const ModDownloadState.downloading(received: 10, total: -1),
      const ModDownloadState.downloaded(record),
    ]);
  });

  test('explicit cancel cancels the token and ends idle', () async {
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    manager.cancel(7);
    expect(token.isCancelled, isTrue);
    onProgress(50, 100); // dropped after cancel
    done.complete(left(const Failure.network()));
    await f;
    expect(states.last, const ModDownloadState.idle());
    expect(states, hasLength(2));
    expect(manager.current(7), isNull);
  });

  test('failure is a failure; a later start works again', () async {
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    done.complete(left(const Failure.network()));
    await f;
    expect(states.last, const ModDownloadState.failure(Failure.network()));

    done = Completer();
    final g = manager.start(mod);
    expect(calls, 2);
    done.complete(right(record));
    await g;
    expect(states.last, const ModDownloadState.downloaded(record));
  });

  test('failed re-download carries the previous copy', () async {
    stubPrevious(record);
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    done.complete(left(const Failure.network()));
    await f;
    expect(
      states.last,
      const ModDownloadState.failure(Failure.network(), record),
    );
  });

  test('failure drops a previous record whose file is gone', () async {
    stubPrevious(record, fileExists: false);
    final states = <ModDownloadState>[];
    manager.watch(7).listen(states.add);
    final f = manager.start(mod);
    done.complete(left(const Failure.network()));
    await f;
    expect(states.last, const ModDownloadState.failure(Failure.network()));
  });

  test('cancel for an unknown id is a no-op', () {
    manager.cancel(99);
  });
}
