import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../network/cache_config.dart';
import '../network/data_version_remote_datasource.dart';
import '../storage/local_store.dart';

/// Clears the HTTP cache when the server `/data-version` differs from the
/// stored one. Never throws and does not return `Either`: it runs at boot,
/// where no UI can show an error.
@lazySingleton
class CacheSyncService {
  CacheSyncService(this._remote, this._localStore, this._store);

  /// Key in [StoreBoxes.settings]; value is an `int`.
  static const String versionKey = 'data_version';

  final DataVersionRemoteDataSource _remote;
  final LocalStore _localStore;
  final CacheStore _store;

  /// Call as the first boot step, before any prefetch.
  Future<void> syncIfStale() async {
    try {
      final remote = (await _remote.getVersion(
        options: forceRefreshOptions(),
      )).version;
      final local = _readLocal();
      if (local == remote) return;
      // Clear first, write the version after: if `clean()` fails the stored
      // version is unchanged, so the next boot retries.
      await _store.clean();
      await _localStore.write<int>(StoreBoxes.settings, versionKey, remote);
      debugPrint('[CacheSync] version $local -> $remote, HTTP cache cleared');
    } catch (error) {
      // Offline or server error: keep the cache, old data beats no data.
      debugPrint('[CacheSync] skipped: $error');
    }
  }

  int? _readLocal() {
    try {
      return _localStore.read<int>(StoreBoxes.settings, versionKey);
    } catch (_) {
      // Broken store: treat as no version, clear once to be safe.
      return null;
    }
  }
}
