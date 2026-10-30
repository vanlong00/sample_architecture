import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_store.dart';
import '../models/favorite_record.dart';

/// Favorites persisted in [StoreBoxes.favorites], keyed by `sourceId`.
/// Throws [CacheException] on storage failure; corrupt entries are skipped.
@lazySingleton
class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this._store);

  final LocalStore _store;

  List<FavoriteRecord> readAll() {
    try {
      final records = <FavoriteRecord>[];
      for (final entry in _store.readAll(StoreBoxes.favorites).entries) {
        try {
          records.add(
            FavoriteRecord.fromJson(
              Map<String, dynamic>.from(entry.value as Map),
            ),
          );
        } catch (e) {
          // Corrupt entry (bad JSON shape / unknown type): ignore it.
          debugPrint('favorites: skip corrupt entry ${entry.key}: $e');
        }
      }
      return records;
    } catch (_) {
      throw CacheException();
    }
  }

  Future<void> write(FavoriteRecord record) async {
    try {
      await _store.write<Map<String, dynamic>>(
        StoreBoxes.favorites,
        '${record.sourceId}',
        record.toJson(),
      );
    } catch (_) {
      throw CacheException();
    }
  }

  Future<void> delete(int sourceId) async {
    try {
      await _store.delete(StoreBoxes.favorites, '$sourceId');
    } catch (_) {
      throw CacheException();
    }
  }
}
