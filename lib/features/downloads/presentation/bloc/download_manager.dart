import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../mods/data/models/mod_detail.dart';
import '../../data/models/mod_download_record.dart';
import '../../data/repositories/download_repository.dart';
import 'mod_download_state.dart';

/// App-scoped owner of in-flight downloads, keyed by sourceId. Cubits only
/// observe, start and cancel through it, so leaving a page never cancels a
/// transfer and two cubits can never download the same mod twice.
///
/// Events: `downloading` while running, then one terminal event:
/// `downloaded`, `failure`, or `idle` after an explicit [cancel].
@lazySingleton
class DownloadManager {
  DownloadManager(this._repository);

  final DownloadRepository _repository;
  final _running = <int, _Transfer>{};
  final _events = StreamController<(int, ModDownloadState)>.broadcast(
    sync: true,
  );

  /// Live state of the running transfer, `null` when none runs.
  ModDownloadState? current(int sourceId) => _running[sourceId]?.state;

  Stream<ModDownloadState> watch(int sourceId) =>
      _events.stream.where((e) => e.$1 == sourceId).map((e) => e.$2);

  /// No-op that attaches to the running transfer when one exists. Completes
  /// when the transfer ends.
  Future<void> start(ModDetail mod) {
    final running = _running[mod.sourceId];
    if (running != null) return running.done;
    final t = _Transfer();
    _running[mod.sourceId] = t;
    _publish(
      mod.sourceId,
      t,
      const ModDownloadState.downloading(received: 0, total: -1),
    );
    return t.done = _run(mod, t);
  }

  /// Explicit user cancel: the repository removes the `.part` file.
  void cancel(int sourceId) {
    final t = _running[sourceId];
    if (t == null) return;
    t.cancelled = true;
    t.token.cancel();
  }

  void _publish(int id, _Transfer t, ModDownloadState s) {
    t.state = s;
    _events.add((id, s));
  }

  Future<void> _run(ModDetail mod, _Transfer t) async {
    final id = mod.sourceId;
    var lastPercent = -1;
    var unknownEmitted = false;
    final result = await _repository.download(
      mod,
      cancelToken: t.token,
      onProgress: (received, total) {
        if (t.token.isCancelled) return;
        if (total <= 0) {
          if (unknownEmitted) return; // ponytail: no percent without a total
          unknownEmitted = true;
        } else {
          final percent = received * 100 ~/ total;
          if (percent == lastPercent) return;
          lastPercent = percent;
        }
        _publish(
          id,
          t,
          ModDownloadState.downloading(
            received: received,
            total: total <= 0 ? -1 : total,
          ),
        );
      },
    );
    // A real cancel surfaces as Failure.network, so trust our own flag.
    final failed = result.isLeft() && !t.cancelled;
    // Failed re-download: the previous copy is still on disk, keep it
    // reachable. Resolved before leaving `_running` so no start() interleaves.
    final previous = failed ? await _previousCopy(id) : null;
    _running.remove(id);
    _events.add((
      id,
      result.fold(
        (f) => t.cancelled
            ? const ModDownloadState.idle()
            : ModDownloadState.failure(f, previous),
        ModDownloadState.downloaded,
      ),
    ));
  }

  /// Stored record of [id] whose file exists, else `null` (best effort).
  Future<ModDownloadRecord?> _previousCopy(int id) async {
    final record = (await _repository.find(id)).toNullable();
    if (record == null) return null;
    final exists = (await _repository.fileExists(record)).toNullable() ?? false;
    return exists ? record : null;
  }
}

class _Transfer {
  final token = CancelToken();
  bool cancelled = false;
  ModDownloadState state = const ModDownloadState.downloading(
    received: 0,
    total: -1,
  );
  late Future<void> done;
}
