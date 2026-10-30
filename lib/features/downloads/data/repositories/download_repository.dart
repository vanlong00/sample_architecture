import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/telemetry.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../../../mods/data/models/mod_detail.dart';
import '../datasources/download_local_datasource.dart';
import '../datasources/download_remote_datasource.dart';
import '../datasources/pbsu_launcher_datasource.dart';
import '../logic/mod_file.dart';
import '../models/mod_download_record.dart';

/// Result of [DownloadRepository.importToGame]. `notInstalled` means the UI
/// must offer the Play Store; `failed` means nothing could open the file.
enum ImportOutcome { sent, notInstalled, chooserOpened, failed }

abstract class DownloadRepository {
  /// Emits after every record write/delete so lists can refresh.
  Stream<void> get changes;

  /// Downloads `mod.download.storageUrl` (F1: never any other URL) to
  /// `mods/<sourceId>.<ext>` and indexes it. `total == -1` in [onProgress]
  /// means unknown size. Bytes go to `<path>.part` and replace the real file only
  /// on success; cancel and error delete just the `.part` and leave any
  /// previous file and record untouched. On cancel the failure is whatever
  /// Dio surfaced, the caller tracks its own cancelled flag.
  Future<Either<Failure, ModDownloadRecord>> download(
    ModDetail mod, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  });

  /// Newest first.
  Future<Either<Failure, List<ModDownloadRecord>>> list();

  Future<Either<Failure, ModDownloadRecord?>> find(int sourceId);

  /// Fails with `Failure.cache` only on storage errors; a missing file is
  /// `right(false)`.
  Future<Either<Failure, bool>> fileExists(ModDownloadRecord record);

  Future<Either<Failure, Unit>> delete(ModDownloadRecord record);

  /// Sends the file to PBSU. `Left(Failure.cache)` when the file is gone (no
  /// launch attempted); otherwise always `Right(outcome)`, never throws.
  Future<Either<Failure, ImportOutcome>> importToGame(ModDownloadRecord record);
}

@LazySingleton(as: DownloadRepository)
class DownloadRepositoryImpl implements DownloadRepository {
  DownloadRepositoryImpl(
    this._remote,
    this._local,
    this._launcher, {
    @ignoreParam int Function()? now,
  }) : _now = now ?? _defaultNow;

  final DownloadRemoteDataSource _remote;
  final DownloadLocalDataSource _local;
  final PbsuLauncherDataSource _launcher;
  final int Function() _now;
  final _changes = StreamController<void>.broadcast();
  final _inFlight = <int, Future<Either<Failure, ModDownloadRecord>>>{};

  static int _defaultNow() => DateTime.now().millisecondsSinceEpoch;

  @override
  Stream<void> get changes => _changes.stream;

  /// A second call for a sourceId already downloading returns the running
  /// transfer's future (its callbacks are ignored): two callers can never
  /// write the same path.
  @override
  Future<Either<Failure, ModDownloadRecord>> download(
    ModDetail mod, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) {
    final running = _inFlight[mod.sourceId];
    if (running != null) return running;
    final run = _download(mod, onProgress, cancelToken);
    _inFlight[mod.sourceId] = run;
    return run.whenComplete(() => _inFlight.remove(mod.sourceId));
  }

  Future<Either<Failure, ModDownloadRecord>> _download(
    ModDetail mod,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  ) => guard(() async {
    // F3/F2: refuse before any network call.
    final url = mod.download?.storageUrl;
    final ext = url == null ? null : fileExtensionOf(url);
    if (!mod.isDownloadable ||
        !isAllowedStorageUrl(url) ||
        url == null ||
        ext == null) {
      throw ServerException(message: 'not downloadable', code: 404);
    }

    final relPath = modRelPath(mod.sourceId, ext);
    final previous = _local.readRecord(mod.sourceId);
    final partPath = await _local.prepareFor(relPath);
    try {
      await _remote.download(
        url: url,
        savePath: partPath,
        onProgress: onProgress,
        cancelToken: cancelToken,
      );
      // Rename + record only on success: until here `previous` (file and
      // record) is untouched.
      await _local.commit(relPath);
    } catch (_) {
      try {
        await _local.deletePart(relPath); // only the partial file
      } catch (e, st) {
        recordError(e, st, reason: 'downloads: partial cleanup');
      }
      rethrow; // always the original error
    }

    // File first, record second: a crash between leaves an invisible orphan,
    // never a record pointing at a missing file.
    final record = ModDownloadRecord(
      sourceId: mod.sourceId,
      title: mod.title,
      thumbUrl: mod.thumbnail,
      type: mod.type,
      relPath: relPath,
      sizeBytes: await _local.sizeOf(relPath),
      createdAtMs: _now(),
    );
    await _local.writeRecord(record);

    // Server changed the extension (.zip -> .rar): the new file is in place,
    // so the old copy is now an orphan.
    final old = previous?.relPath;
    if (old != null && old != relPath) {
      try {
        await _local.deleteFile(old);
      } catch (e, st) {
        recordError(e, st, reason: 'downloads: old file cleanup');
      }
    }

    _changes.add(null);
    return record;
  });

  @override
  Future<Either<Failure, List<ModDownloadRecord>>> list() => guard(
    () async =>
        _local.readRecords()
          ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs)),
  );

  @override
  Future<Either<Failure, ModDownloadRecord?>> find(int sourceId) =>
      guard(() async => _local.readRecord(sourceId));

  @override
  Future<Either<Failure, bool>> fileExists(ModDownloadRecord record) =>
      guard(() => _local.fileExists(record.relPath));

  @override
  Future<Either<Failure, Unit>> delete(ModDownloadRecord record) =>
      guard(() async {
        // Record first, file second: the reverse briefly shows a row whose
        // file is gone.
        await _local.deleteRecord(record.sourceId);
        try {
          await _local.deleteFile(record.relPath);
        } finally {
          _changes.add(null); // the record is gone either way
        }
        return unit;
      });

  @override
  Future<Either<Failure, ImportOutcome>> importToGame(
    ModDownloadRecord record,
  ) => guard(() async {
    if (!await _local.fileExists(record.relPath)) throw CacheException();
    if (!await _launcher.isInstalled()) return ImportOutcome.notInstalled;

    final path = await _local.absolutePathOf(record.relPath);
    final mime = importMimeFor(record.extension);
    try {
      await _launcher.launch(path: path, mime: mime);
      return ImportOutcome.sent;
    } on PlatformException {
      try {
        final opened = await _launcher.openWithChooser(path: path, mime: mime);
        return opened ? ImportOutcome.chooserOpened : ImportOutcome.failed;
      } catch (_) {
        return ImportOutcome.failed;
      }
    }
  });
}
