import 'dart:async';
import 'dart:io';

import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/storage/kv_entry.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_setup.dart';

ModDownloadRecord rec(int id, {int at = 1}) => ModDownloadRecord(
  sourceId: id,
  title: 'Mod $id',
  thumbUrl: 'http://t/$id.png',
  type: ModType.bus,
  relPath: 'mods/$id.RAR',
  sizeBytes: 3,
  createdAtMs: at,
);

/// Real Isar store with two test seams for the corrupt-drop race.
class _HookedStore extends LocalStore {
  Future<void> Function()? afterDelete;
  String? staleCorruptKey;

  @override
  Future<void> delete(String box, String key) async {
    await super.delete(box, key);
    final hook = afterDelete;
    afterDelete = null;
    await hook?.call();
  }

  @override
  Map<String, String> readAllRaw(String box) {
    final all = super.readAllRaw(box);
    final key = staleCorruptKey;
    staleCorruptKey = null;
    return key == null ? all : {...all, key: '{not json'};
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _HookedStore store;
  late Directory support;
  late DownloadLocalDataSource ds;

  setUp(() async {
    await initIsarCoreForTests();
    store = _HookedStore();
    await store.init(
      directory: (await Directory.systemTemp.createTemp(
        'busmod_local_hook',
      )).path,
    );
    support = await Directory.systemTemp.createTemp('busmod_support');
    ds = DownloadLocalDataSource(store, supportDir: () async => support.path);
  });
  tearDown(() async {
    await store.close(deleteFromDisk: true);
    await support.delete(recursive: true);
  });

  test('record round trip, upsert by sourceId, delete', () async {
    expect(ds.readRecords(), isEmpty);
    expect(ds.readRecord(1), isNull);
    await ds.writeRecord(rec(1));
    await ds.writeRecord(rec(2));
    await ds.writeRecord(rec(1, at: 9));
    expect(ds.readRecord(1), rec(1, at: 9));
    final all = ds.readRecords()..sort((a, b) => a.sourceId - b.sourceId);
    expect(all, [rec(1, at: 9), rec(2)]);
    await ds.deleteRecord(1);
    expect(ds.readRecords(), [rec(2)]);
  });

  test('corrupt record: null on read, removed with its file on list', () async {
    await store.write(StoreBoxes.modDownloads, '5', {'bad': 1});
    await ds.writeRecord(rec(1));
    expect(ds.readRecord(5), isNull); // reported, entry kept
    expect(store.read<Object>(StoreBoxes.modDownloads, '5'), isNotNull);

    final orphan = File('${support.path}/mods/5.zip')
      ..createSync(recursive: true);
    final part = File('${support.path}/mods/5.zip.part')..createSync();
    final other = File('${support.path}/mods/55.zip')..createSync();
    expect(ds.readRecords(), [rec(1)]);
    // cleanup is fire-and-forget on real IO: poll for it
    for (var i = 0; i < 100 && orphan.existsSync(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    expect(store.read<Object>(StoreBoxes.modDownloads, '5'), isNull);
    expect(orphan.existsSync(), isFalse);
    expect(part.existsSync(), isTrue); // in-progress download untouched
    expect(other.existsSync(), isTrue);
  });

  test(
    'undecodable stored value: readRecord is null, not CacheException',
    () async {
      final isar = Isar.getInstance()!;
      await isar.writeTxn(
        () => isar.kvEntrys.putByBoxKey(
          KvEntry()
            ..box = StoreBoxes.modDownloads
            ..key = '8'
            ..value = '{not json',
        ),
      );
      expect(ds.readRecord(8), isNull);
      expect(store.readRaw(StoreBoxes.modDownloads, '8'), '{not json'); // kept
    },
  );

  test(
    'drop of a corrupt entry never deletes a record written meanwhile',
    () async {
      await store.write(StoreBoxes.modDownloads, '5', {'bad': 1});
      final file = File('${support.path}/mods/5.zip')
        ..createSync(recursive: true);
      final deleted = Completer<void>();
      // A fresh record lands right after the corrupt entry was deleted, before
      // the file sweep.
      store.afterDelete = () async {
        await store.write(StoreBoxes.modDownloads, '5', rec(5).toJson());
        deleted.complete();
      };

      ds.readRecords();
      await deleted.future;
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(ds.readRecord(5), rec(5));
      expect(file.existsSync(), isTrue);
    },
  );

  test('entry fixed before the drop runs is not dropped at all', () async {
    await ds.writeRecord(rec(6));
    final file = File('${support.path}/mods/6.RAR')
      ..createSync(recursive: true);
    store.staleCorruptKey = '6'; // the list read sees it corrupt once
    ds.readRecords();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(ds.readRecord(6), rec(6));
    expect(file.existsSync(), isTrue);
  });

  test(
    'tampered relPath is treated as corrupt: null, dropped from list',
    () async {
      final bad = {
        '1': 'mods/../x.zip',
        '2': '/data/data/x/2.zip',
        '3': 'other/3.zip',
        '4': 'mods/9.zip', // number differs from sourceId
        '5': 'mods/5.zip/../../x',
        '6': 'mods/6.',
      };
      for (final e in bad.entries) {
        await store.write(
          StoreBoxes.modDownloads,
          e.key,
          rec(int.parse(e.key)).toJson()..['relPath'] = e.value,
        );
        expect(ds.readRecord(int.parse(e.key)), isNull, reason: e.value);
      }
      await ds.writeRecord(rec(7));
      expect(ds.readRecords(), [rec(7)]);
      for (
        var i = 0;
        i < 50 && store.readAllRaw(StoreBoxes.modDownloads).length > 1;
        i++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(store.readAllRaw(StoreBoxes.modDownloads).keys, ['7']);
    },
  );

  test('undecodable JSON value: that entry is dropped, the rest lists', () async {
    await ds.writeRecord(rec(1));
    await store.write(StoreBoxes.modDownloads, '2', {'bad': 1});
    // Raw undecodable value: LocalStore.write always jsonEncodes, so go to Isar.
    final isar = Isar.getInstance()!;
    await isar.writeTxn(
      () => isar.kvEntrys.putByBoxKey(
        KvEntry()
          ..box = StoreBoxes.modDownloads
          ..key = '3'
          ..value = '{not json',
      ),
    );
    await ds.writeRecord(rec(4));

    final all = ds.readRecords()..sort((a, b) => a.sourceId - b.sourceId);
    expect(all, [rec(1), rec(4)]);
    for (
      var i = 0;
      i < 100 && store.readAllRaw(StoreBoxes.modDownloads).containsKey('3');
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(store.readAllRaw(StoreBoxes.modDownloads).keys.toSet(), {'1', '4'});
  });

  test(
    'file lifecycle: .part, commit over the real file, deletePart',
    () async {
      expect(
        await ds.absolutePathOf('mods/1.zip'),
        '${support.path}/mods/1.zip',
      );
      expect(await ds.fileExists('mods/1.zip'), isFalse);
      await ds.deleteFile('mods/1.zip'); // missing: no throw

      final real = File('${support.path}/mods/1.zip');
      final path = await ds.prepareFor('mods/1.zip');
      expect(path, '${support.path}/mods/1.zip.part');
      expect(Directory('${support.path}/mods').existsSync(), isTrue);

      // the real file is untouched until commit
      real.writeAsBytesSync([7]);
      File(path).writeAsBytesSync([1, 2, 3]);
      expect(real.readAsBytesSync(), [7]);
      await ds.commit('mods/1.zip');
      expect(File(path).existsSync(), isFalse);
      expect(real.readAsBytesSync(), [1, 2, 3]);
      expect(await ds.sizeOf('mods/1.zip'), 3);

      // stale .part cleared, deletePart leaves the committed file
      File(path).writeAsBytesSync([9]);
      await ds.prepareFor('mods/1.zip');
      expect(File(path).existsSync(), isFalse);
      File(path).writeAsBytesSync([9]);
      await ds.deletePart('mods/1.zip');
      expect(File(path).existsSync(), isFalse);
      expect(real.existsSync(), isTrue);

      await ds.deleteFile('mods/1.zip');
      expect(real.existsSync(), isFalse);
    },
  );

  test('commit without a .part -> CacheException', () {
    expect(ds.commit('mods/none.zip'), throwsA(isA<CacheException>()));
  });

  test('sizeOf missing file -> CacheException', () {
    expect(ds.sizeOf('mods/none.zip'), throwsA(isA<CacheException>()));
  });
}
