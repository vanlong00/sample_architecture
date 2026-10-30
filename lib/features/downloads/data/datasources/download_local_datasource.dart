import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/analytics/telemetry.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_store.dart';
import '../models/mod_download_record.dart';

/// Only place of the downloads feature that touches the file system and
/// [StoreBoxes.modDownloads]. Throws [CacheException] on any error; corrupt
/// records are reported, skipped and removed.
///
/// Files live under the app SUPPORT dir (Android `files/`), not documents:
/// that matches the FileProvider `<files-path>` used to hand the file to the
/// game. [supportDir] is a seam for tests.
@lazySingleton
class DownloadLocalDataSource {
  DownloadLocalDataSource(
    this._store, {
    @ignoreParam Future<String> Function()? supportDir,
  }) : _supportDir = supportDir ?? _defaultSupportDir;

  final LocalStore _store;
  final Future<String> Function() _supportDir;

  static Future<String> _defaultSupportDir() async =>
      (await getApplicationSupportDirectory()).path;

  Future<String> absolutePathOf(String relPath) async =>
      '${await _supportDir()}/$relPath';

  static String _part(String relPath) => '$relPath.part';

  /// Creates the parent dir, clears a stale `.part` and returns the absolute
  /// path of `<relPath>.part`. The real file is never touched until
  /// [commit], so a failed re-download cannot destroy the previous copy.
  Future<String> prepareFor(String relPath) async {
    try {
      final part = File(await absolutePathOf(_part(relPath)));
      await part.parent.create(recursive: true);
      if (await part.exists()) await part.delete();
      return part.path;
    } catch (_) {
      throw CacheException();
    }
  }

  /// Atomically renames `<relPath>.part` over [relPath].
  Future<void> commit(String relPath) async {
    try {
      await File(
        await absolutePathOf(_part(relPath)),
      ).rename(await absolutePathOf(relPath));
    } catch (_) {
      throw CacheException();
    }
  }

  /// Removes only the `.part` file; the committed file stays.
  Future<void> deletePart(String relPath) => deleteFile(_part(relPath));

  Future<bool> fileExists(String relPath) async {
    try {
      return await File(await absolutePathOf(relPath)).exists();
    } catch (_) {
      throw CacheException();
    }
  }

  Future<int> sizeOf(String relPath) async {
    try {
      return await File(await absolutePathOf(relPath)).length();
    } catch (_) {
      throw CacheException();
    }
  }

  /// No throw if the file is already missing.
  Future<void> deleteFile(String relPath) async {
    try {
      final file = File(await absolutePathOf(relPath));
      if (await file.exists()) await file.delete();
    } catch (_) {
      throw CacheException();
    }
  }

  List<ModDownloadRecord> readRecords() {
    try {
      final records = <ModDownloadRecord>[];
      for (final entry in _store.readAllRaw(StoreBoxes.modDownloads).entries) {
        try {
          records.add(_decode(jsonDecode(entry.value)));
        } catch (e, st) {
          recordError(e, st, reason: 'downloads: corrupt record ${entry.key}');
          unawaited(_dropCorrupt(entry.key));
        }
      }
      return records;
    } catch (_) {
      throw CacheException();
    }
  }

  /// Best effort: removes the corrupt entry and any `<key>.*` file (its
  /// extension is unknown) so nothing is left orphaned. In-progress `.part`
  /// files are kept.
  Future<void> _dropCorrupt(String key) async {
    try {
      await _store.delete(StoreBoxes.modDownloads, key);
      final dir = Directory(await absolutePathOf('mods'));
      if (!await dir.exists()) return;
      await for (final e in dir.list()) {
        final name = e.path.substring(e.path.lastIndexOf('/') + 1);
        if (e is File && name.startsWith('$key.') && !name.endsWith('.part')) {
          await e.delete();
        }
      }
    } catch (e, st) {
      recordError(e, st, reason: 'downloads: dropping corrupt record $key');
    }
  }

  /// `null` when absent or corrupt (reported, not removed: the next download
  /// overwrites it).
  ModDownloadRecord? readRecord(int sourceId) {
    try {
      final raw = _store.read<Object>(StoreBoxes.modDownloads, '$sourceId');
      if (raw == null) return null;
      try {
        return _decode(raw);
      } catch (e, st) {
        recordError(e, st, reason: 'downloads: corrupt record $sourceId');
        return null;
      }
    } catch (_) {
      throw CacheException();
    }
  }

  Future<void> writeRecord(ModDownloadRecord record) async {
    try {
      await _store.write<Map<String, dynamic>>(
        StoreBoxes.modDownloads,
        record.key,
        record.toJson(),
      );
    } catch (_) {
      throw CacheException();
    }
  }

  Future<void> deleteRecord(int sourceId) async {
    try {
      await _store.delete(StoreBoxes.modDownloads, '$sourceId');
    } catch (_) {
      throw CacheException();
    }
  }

  static ModDownloadRecord _decode(Object? raw) =>
      ModDownloadRecord.fromJson(Map<String, dynamic>.from(raw! as Map));
}
