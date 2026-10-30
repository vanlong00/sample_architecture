import 'dart:async';
import 'dart:io';

import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/storage/kv_entry.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart';
import 'package:busmod/features/downloads/data/logic/mod_file.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/isar_test_setup.dart';

class _MockRemote extends Mock implements DownloadRemoteDataSource {}

class _MockLauncher extends Mock implements PbsuLauncherDataSource {}

ModDetail mod(int id, {String? url, String title = 'T'}) => ModDetail(
  sourceId: id,
  type: ModType.bus,
  title: title,
  media: const ModMedia(thumbnail: 'http://t/x.png'),
  download: url == null ? null : ModDownload(storageUrl: url),
);

const _badUrls = [
  'file:///sdcard/a.zip',
  'ftp://cdn.x/a.zip',
  'https://www.mediafire.com/file/a.zip',
  'https://f000.backblazeb2.com/file/a.zip',
  'https://backblaze.com/a.zip',
  'https://evil.com@www.mediafire.com/a.zip',
  'https://MEDIAFIRE.com./a.zip',
  'https:///a.zip',
  '/files/a.zip',
  'a.zip',
  'javascript:alert(1)//a.zip',
];

class _ThrowingExistsLocal extends DownloadLocalDataSource {
  _ThrowingExistsLocal(super.store, String dir)
    : super(supportDir: () async => dir);

  @override
  Future<bool> fileExists(String relPath) async => throw CacheException();
}

class _ThrowingPartLocal extends DownloadLocalDataSource {
  _ThrowingPartLocal(super.store, String dir)
    : super(supportDir: () async => dir);

  @override
  Future<void> deletePart(String relPath) async => throw CacheException();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;
  late Directory support;
  late DownloadLocalDataSource local;
  late _MockRemote remote;
  late _MockLauncher launcher;
  late DownloadRepositoryImpl repo;
  var clock = 0;

  /// Stubs the remote to write [bytes] to the requested savePath.
  void stubWrite(List<int> bytes) {
    when(
      () => remote.download(
        url: any(named: 'url'),
        savePath: any(named: 'savePath'),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((i) async {
      final path = i.namedArguments[#savePath] as String;
      File(path).writeAsBytesSync(bytes);
      (i.namedArguments[#onProgress] as void Function(int, int)?)?.call(
        bytes.length,
        -1,
      );
    });
  }

  void stubThrow(Object e) {
    when(
      () => remote.download(
        url: any(named: 'url'),
        savePath: any(named: 'savePath'),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((i) async {
      File(i.namedArguments[#savePath] as String).writeAsBytesSync([9]);
      throw e;
    });
  }

  bool onDisk(String rel) => File('${support.path}/$rel').existsSync();

  setUp(() async {
    store = await openTestStore();
    support = await Directory.systemTemp.createTemp('busmod_support');
    local = DownloadLocalDataSource(
      store,
      supportDir: () async => support.path,
    );
    remote = _MockRemote();
    launcher = _MockLauncher();
    clock = 0;
    repo = DownloadRepositoryImpl(remote, local, launcher, now: () => ++clock);
  });
  tearDown(() async {
    await store.close(deleteFromDisk: true);
    await support.delete(recursive: true);
  });

  test(
    'downloads EXACTLY storageUrl to mods/<id>.<ext>, writes record',
    () async {
      stubWrite([1, 2, 3]);
      const url = 'https://cdn.x/files/abc.RAR?sig=1';
      final progress = <(int, int)>[];

      final r = await repo.download(
        mod(12, url: url, title: 'Bus'),
        onProgress: (a, t) => progress.add((a, t)),
      );

      final rec = r.getOrElse((_) => fail('expected Right'));
      expect(rec.relPath, 'mods/12.RAR');
      expect(rec.sizeBytes, 3);
      expect(rec.title, 'Bus');
      expect(rec.thumbUrl, 'http://t/x.png');
      expect(rec.createdAtMs, 1);
      expect(onDisk('mods/12.RAR'), isTrue);
      expect(local.readRecord(12), rec);
      expect(progress, [(3, -1)]); // total -1 forwarded untouched
      verify(
        () => remote.download(
          url: url,
          savePath: '${support.path}/mods/12.RAR.part',
          onProgress: any(named: 'onProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    },
  );

  for (final m in [
    mod(1), // no download
    mod(2, url: ''), // not mirrored
    mod(3, url: 'https://cdn.x/files/noext'), // F2
    // F1: scheme / host
    for (var i = 0; i < _badUrls.length; i++) mod(10 + i, url: _badUrls[i]),
  ]) {
    test('refused without network: sourceId ${m.sourceId}', () async {
      final r = await repo.download(m);
      expect(
        r.swap().getOrElse((_) => fail('expected Left')),
        isA<ServerFailure>().having((f) => f.code, 'code', 404),
      );
      verifyZeroInteractions(remote);
      expect(local.readRecords(), isEmpty);
    });
  }

  test('error: .part deleted, no file, no record', () async {
    stubThrow(DioException(requestOptions: RequestOptions()));
    final r = await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
    expect(r.isLeft(), isTrue);
    expect(onDisk('mods/1.zip'), isFalse);
    expect(onDisk('mods/1.zip.part'), isFalse);
    expect(local.readRecord(1), isNull);
  });

  test('cancel: .part deleted, no record, Left', () async {
    final token = CancelToken();
    stubThrow(
      DioException.requestCancelled(
        requestOptions: RequestOptions(),
        reason: 'x',
      ),
    );
    final r = await repo.download(
      mod(1, url: 'https://cdn.x/a.zip'),
      cancelToken: token,
    );
    expect(r.isLeft(), isTrue);
    expect(onDisk('mods/1.zip'), isFalse);
    expect(onDisk('mods/1.zip.part'), isFalse);
    expect(local.readRecord(1), isNull);
  });

  test('bytes go to <path>.part and only a success renames', () async {
    String? seen;
    when(
      () => remote.download(
        url: any(named: 'url'),
        savePath: any(named: 'savePath'),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((i) async {
      seen = i.namedArguments[#savePath] as String;
      File(seen!).writeAsBytesSync([1, 2]);
      expect(onDisk('mods/1.zip'), isFalse); // not in place mid-transfer
    });
    await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
    expect(seen, '${support.path}/mods/1.zip.part');
    expect(onDisk('mods/1.zip'), isTrue);
    expect(onDisk('mods/1.zip.part'), isFalse);
  });

  test('re-download overwrites file and replaces record', () async {
    stubWrite([1, 2, 3]);
    await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
    stubWrite([1, 2, 3, 4, 5]);
    final r = await repo.download(mod(1, url: 'https://cdn.x/a.zip'));

    expect(r.isRight(), isTrue);
    expect(File('${support.path}/mods/1.zip').readAsBytesSync(), hasLength(5));
    expect(local.readRecords(), hasLength(1));
    expect(local.readRecord(1)!.sizeBytes, 5);
    expect(local.readRecord(1)!.createdAtMs, 2);
  });

  test('re-download with another extension removes the old file', () async {
    stubWrite([1]);
    await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
    await repo.download(mod(1, url: 'https://cdn.x/a.rar'));
    expect(onDisk('mods/1.zip'), isFalse);
    expect(onDisk('mods/1.rar'), isTrue);
    expect(local.readRecord(1)!.relPath, 'mods/1.rar');
  });

  test('failed re-download keeps the previous file and record', () async {
    stubWrite([1, 2]);
    final first = (await repo.download(
      mod(1, url: 'https://cdn.x/a.zip'),
    )).getOrElse((_) => fail('Left'));
    stubThrow(DioException(requestOptions: RequestOptions()));
    expect(
      (await repo.download(mod(1, url: 'https://cdn.x/a.zip'))).isLeft(),
      isTrue,
    );
    expect(File('${support.path}/mods/1.zip').readAsBytesSync(), [1, 2]);
    expect(onDisk('mods/1.zip.part'), isFalse);
    expect(local.readRecord(1), first);
  });

  test(
    'failed re-download with another extension keeps the old file',
    () async {
      stubWrite([1, 2]);
      final first = (await repo.download(
        mod(1, url: 'https://cdn.x/a.zip'),
      )).getOrElse((_) => fail('Left'));
      stubThrow(DioException(requestOptions: RequestOptions()));
      await repo.download(mod(1, url: 'https://cdn.x/a.rar'));
      expect(onDisk('mods/1.zip'), isTrue);
      expect(onDisk('mods/1.rar'), isFalse);
      expect(local.readRecord(1), first);
    },
  );

  test('cleanup failure never replaces the original error', () async {
    final failing = _ThrowingPartLocal(store, support.path);
    final r = DownloadRepositoryImpl(remote, failing, launcher);
    final original = DioException(requestOptions: RequestOptions());
    stubThrow(original);
    final result = await r.download(mod(1, url: 'https://cdn.x/a.zip'));
    expect(result.isLeft(), isTrue);
    expect(
      result.swap().getOrElse((_) => fail('Left')),
      isNot(
        isA<CacheFailure>(),
      ), // the Dio error was mapped, not CacheException
    );
  });

  test(
    'undecodable stored value: find is right(null), re-download works',
    () async {
      final isar = Isar.getInstance()!;
      await isar.writeTxn(
        () => isar.kvEntrys.putByBoxKey(
          KvEntry()
            ..box = StoreBoxes.modDownloads
            ..key = '1'
            ..value = '{not json',
        ),
      );
      expect(
        await repo.find(1),
        const Right<Failure, ModDownloadRecord?>(null),
      );

      stubWrite([1, 2, 3]);
      final r = await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
      expect(r.isRight(), isTrue);
      expect((await repo.find(1)).toNullable()?.sourceId, 1);
    },
  );

  test('concurrent download of one sourceId is one transfer', () async {
    final gate = Completer<void>();
    var calls = 0;
    when(
      () => remote.download(
        url: any(named: 'url'),
        savePath: any(named: 'savePath'),
        onProgress: any(named: 'onProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((i) async {
      calls++;
      await gate.future;
      File(i.namedArguments[#savePath] as String).writeAsBytesSync([1]);
    });
    final m = mod(1, url: 'https://cdn.x/a.zip');
    final a = repo.download(m);
    final b = repo.download(m);
    gate.complete();
    expect(await a, await b);
    expect(calls, 1);

    // finished: a later download starts a new transfer
    await repo.download(m);
    expect(calls, 2);
  });

  test('list newest first, find', () async {
    stubWrite([1]);
    await repo.download(mod(1, url: 'https://cdn.x/a.zip'));
    await repo.download(mod(2, url: 'https://cdn.x/b.zip'));
    await repo.download(mod(3, url: 'https://cdn.x/c.zip'));
    final list = (await repo.list()).getOrElse((_) => fail('Left'));
    expect(list.map((e) => e.sourceId), [3, 2, 1]);
    expect((await repo.find(2)).getOrElse((_) => fail('Left'))!.sourceId, 2);
    expect((await repo.find(99)).getOrElse((_) => fail('Left')), isNull);
  });

  test('fileExists true then false after external delete', () async {
    stubWrite([1]);
    final rec = (await repo.download(
      mod(1, url: 'https://cdn.x/a.zip'),
    )).getOrElse((_) => fail('Left'));
    expect(await repo.fileExists(rec), const Right<Failure, bool>(true));
    File('${support.path}/${rec.relPath}').deleteSync();
    expect(await repo.fileExists(rec), const Right<Failure, bool>(false));
  });

  test('delete: record first, file second; tolerates missing file', () async {
    stubWrite([1]);
    final rec = (await repo.download(
      mod(1, url: 'https://cdn.x/a.zip'),
    )).getOrElse((_) => fail('Left'));
    expect((await repo.delete(rec)).isRight(), isTrue);
    expect(local.readRecord(1), isNull);
    expect(onDisk(rec.relPath), isFalse);
    expect((await repo.delete(rec)).isRight(), isTrue);
  });

  test('changes emits after write and delete', () async {
    stubWrite([1]);
    var n = 0;
    final sub = repo.changes.listen((_) => n++);
    final rec = (await repo.download(
      mod(1, url: 'https://cdn.x/a.zip'),
    )).getOrElse((_) => fail('Left'));
    await pumpEventQueue();
    expect(n, 1);
    await repo.delete(rec);
    await pumpEventQueue();
    expect(n, 2);
    await sub.cancel();
  });

  group('importToGame', () {
    Future<ModDownloadRecord> downloaded(String url) async {
      stubWrite([1]);
      return (await repo.download(
        mod(7, url: url),
      )).getOrElse((_) => fail('Left'));
    }

    void stubLaunch([Object? error]) {
      final call = when(
        () => launcher.launch(
          path: any(named: 'path'),
          mime: any(named: 'mime'),
        ),
      );
      error == null ? call.thenAnswer((_) async {}) : call.thenThrow(error);
    }

    void stubChooser(Object result) {
      final call = when(
        () => launcher.openWithChooser(
          path: any(named: 'path'),
          mime: any(named: 'mime'),
        ),
      );
      result is bool
          ? call.thenAnswer((_) async => result)
          : call.thenThrow(result);
    }

    final platformError = PlatformException(code: 'ACTIVITY_NOT_FOUND');

    Future<ImportOutcome> import(ModDownloadRecord rec) async =>
        (await repo.importToGame(rec)).getOrElse((_) => fail('expected Right'));

    test('missing file: fileMissing, launcher untouched', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      File('${support.path}/${rec.relPath}').deleteSync();
      expect(await import(rec), ImportOutcome.fileMissing);
      verifyZeroInteractions(launcher);
    });

    test('storage error while checking: Left cache, NOT fileMissing', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      final failing = _ThrowingExistsLocal(store, support.path);
      final r = await DownloadRepositoryImpl(
        remote,
        failing,
        launcher,
      ).importToGame(rec);
      expect(
        r.swap().getOrElse((_) => fail('expected Left')),
        isA<CacheFailure>(),
      );
      verifyZeroInteractions(launcher);
    });

    test('not installed: notInstalled, launch never called', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenAnswer((_) async => false);
      expect(await import(rec), ImportOutcome.notInstalled);
      verifyNever(
        () => launcher.launch(
          path: any(named: 'path'),
          mime: any(named: 'mime'),
        ),
      );
    });

    test('installed + ok: sent with exact absolute path and mime', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenAnswer((_) async => true);
      stubLaunch();
      expect(await import(rec), ImportOutcome.sent);
      verify(
        () => launcher.launch(
          path: '${support.path}/mods/7.zip',
          mime: importMimeFor('zip'),
        ),
      ).called(1);
      verifyNever(
        () => launcher.openWithChooser(
          path: any(named: 'path'),
          mime: any(named: 'mime'),
        ),
      );
    });

    test('F2: mime comes from importMimeFor(record extension)', () async {
      final rec = await downloaded('https://cdn.x/a.RAR');
      when(() => launcher.isInstalled()).thenAnswer((_) async => true);
      stubLaunch();
      await import(rec);
      verify(
        () => launcher.launch(
          path: '${support.path}/mods/7.RAR',
          mime: importMimeFor('RAR'),
        ),
      ).called(1);
    });

    test('launch PlatformException + chooser true: chooserOpened', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenAnswer((_) async => true);
      stubLaunch(platformError);
      stubChooser(true);
      expect(await import(rec), ImportOutcome.chooserOpened);
      verify(
        () => launcher.openWithChooser(
          path: '${support.path}/mods/7.zip',
          mime: importMimeFor('zip'),
        ),
      ).called(1);
    });

    test('launch PlatformException + chooser false: failed', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenAnswer((_) async => true);
      stubLaunch(platformError);
      stubChooser(false);
      expect(await import(rec), ImportOutcome.failed);
    });

    test('launch PlatformException + chooser throws: failed', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenAnswer((_) async => true);
      stubLaunch(platformError);
      stubChooser(StateError('boom'));
      expect(await import(rec), ImportOutcome.failed);
    });

    test('isInstalled throws: Left, never throws out', () async {
      final rec = await downloaded('https://cdn.x/a.zip');
      when(() => launcher.isInstalled()).thenThrow(platformError);
      expect((await repo.importToGame(rec)).isLeft(), isTrue);
    });
  });
}
