import 'dart:convert';
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'kv_entry.dart';

/// Key namespaces of [LocalStore]. Each data group stays separately listable.
class StoreBoxes {
  static const String settings = 'settings';

  /// Index of downloaded mods: key = modId, value = JSON of the download
  /// record. Separate from [favorites]: a download is a fact on disk, a
  /// favorite is a user intent.
  static const String modDownloads = 'mod_downloads';

  /// Mods the user marked as favorite: key = modId, value = JSON record.
  static const String favorites = 'favorites';
}

/// Namespaced string key-value store over Isar. Reads are synchronous, writes
/// are async. Values are JSON-encoded, so `bool`/`int`/`String`/`List`/`Map`
/// round-trip with their type.
///
/// Create it, then `await init()` once before use (DI does this in
/// `configureDependencies`).
class LocalStore {
  Isar? _isar;
  String? _directory;

  /// Directory of the open database, `null` while closed.
  String? get directory => _directory;

  Isar get _db {
    final isar = _isar;
    if (isar == null) {
      throw StateError('LocalStore.init() has not been called');
    }
    return isar;
  }

  /// Opens Isar in [directory] (default: app documents). Safe to call twice.
  Future<void> init({String? directory}) async {
    if (_isar != null) return;
    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    try {
      _isar = await Isar.open([KvEntrySchema], directory: dir);
    } on IsarError catch (e) {
      // Only a file left by an older, incompatible Isar engine is recovered
      // by deleting it. Any other IsarError (OOM, bad schema) must surface
      // instead of silently deleting user data.
      if (!e.toString().contains('MDBX_INCOMPATIBLE')) rethrow;
      for (final suffix in ['default.isar', 'default.isar.lock']) {
        final file = File('$dir/$suffix');
        if (file.existsSync()) await file.delete();
      }
      _isar = await Isar.open([KvEntrySchema], directory: dir);
    }
    _directory = dir;
  }

  /// Decoded value, or `null` when absent. Throws if [T] does not match.
  T? read<T>(String box, String key) {
    final entry = _db.kvEntrys.getByBoxKeySync(box, key);
    if (entry == null) return null;
    return jsonDecode(entry.value) as T?;
  }

  /// Raw (undecoded) JSON string of [key], or `null` when absent: lets a caller
  /// decode inside its own try so a corrupt value cannot throw from here.
  String? readRaw(String box, String key) =>
      _db.kvEntrys.getByBoxKeySync(box, key)?.value;

  /// Upsert: writing an existing key overwrites it.
  Future<void> write<T>(String box, String key, T value) async {
    final entry = KvEntry()
      ..box = box
      ..key = key
      ..value = jsonEncode(value);
    await _db.writeTxn(() => _db.kvEntrys.putByBoxKey(entry));
  }

  Future<void> delete(String box, String key) async {
    await _db.writeTxn(() => _db.kvEntrys.deleteByBoxKey(box, key));
  }

  /// Every decoded value of [box], keyed by its key.
  Map<String, dynamic> readAll(String box) => {
    for (final e in _db.kvEntrys.filter().boxEqualTo(box).findAllSync())
      e.key: jsonDecode(e.value),
  };

  /// Raw (undecoded) JSON strings of [box]: lets a caller decode per entry
  /// so one corrupt value cannot fail the whole list.
  Map<String, String> readAllRaw(String box) => {
    for (final e in _db.kvEntrys.filter().boxEqualTo(box).findAllSync())
      e.key: e.value,
  };

  Future<void> close({bool deleteFromDisk = false}) async {
    await _isar?.close(deleteFromDisk: deleteFromDisk);
    _isar = null;
    if (deleteFromDisk) _directory = null;
  }
}
