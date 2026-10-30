import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../mods/data/models/mod_detail.dart';
import '../../data/models/mod_download_record.dart';
import '../../data/repositories/download_repository.dart';
import 'download_manager.dart';
import 'mod_download_state.dart';

/// Observes the app-scoped [DownloadManager]; closing it never cancels a
/// transfer.
@injectable
class ModDownloadCubit extends Cubit<ModDownloadState> {
  ModDownloadCubit(this._repository, this._manager)
    : super(const ModDownloadState.checking());

  final DownloadRepository _repository;
  final DownloadManager _manager;
  StreamSubscription<ModDownloadState>? _sub;
  int? _sourceId;
  int _events = 0; // bumps on every manager event: invalidates stale checks

  void _attach(int sourceId) {
    if (_sourceId == sourceId) return;
    _sub?.cancel();
    _sourceId = sourceId;
    _sub = _manager.watch(sourceId).listen((s) {
      _events++;
      // Cancelled (or nothing to show): re-resolve, the previous copy of a
      // re-download is still on disk.
      s is ModDownloadIdle ? unawaited(_resolve(sourceId)) : emit(s);
    });
  }

  /// Resolves the state of the download button for [sourceId]: a running
  /// transfer first, then the stored record.
  Future<void> check(int sourceId) async {
    _attach(sourceId);
    final live = _manager.current(sourceId);
    if (live != null) return emit(live);
    if (state is ModDownloadCheckFailure) {
      emit(const ModDownloadState.checking());
    }
    await _resolve(sourceId);
  }

  Future<void> _resolve(int sourceId) async {
    final gen = _events;
    bool stale() => isClosed || gen != _events;
    final found = await _repository.find(sourceId);
    if (stale()) return;
    await found.match((f) async => emit(ModDownloadState.checkFailure(f)), (
      record,
    ) async {
      if (record == null) return emit(const ModDownloadState.idle());
      final exists = await _repository.fileExists(record);
      if (stale()) return;
      emit(
        exists.fold(
          ModDownloadState.checkFailure,
          (ok) => ok
              ? ModDownloadState.downloaded(record)
              : ModDownloadState.fileMissing(record),
        ),
      );
    });
  }

  /// A second start for the same mod attaches to the running transfer.
  Future<void> start(ModDetail mod) {
    _attach(mod.sourceId);
    return _manager.start(mod);
  }

  void cancel() {
    final id = _sourceId;
    if (id != null) _manager.cancel(id);
  }

  /// No state change: the UI shows feedback from the outcome.
  Future<Either<Failure, ImportOutcome>> importToGame(
    ModDownloadRecord record,
  ) => _repository.importToGame(record);

  @override
  Future<void> close() async {
    await _sub?.cancel(); // the transfer itself keeps running
    return super.close();
  }
}
