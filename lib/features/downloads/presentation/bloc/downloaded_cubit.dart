import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_download_record.dart';
import '../../data/repositories/download_repository.dart';
import 'downloaded_state.dart';

@injectable
class DownloadedCubit extends Cubit<DownloadedState> {
  DownloadedCubit(this._repository) : super(const DownloadedState.initial()) {
    _sub = _repository.changes.listen((_) => _refresh());
  }

  final DownloadRepository _repository;
  late final StreamSubscription<void> _sub;
  int _seq = 0; // drops results of superseded refreshes
  Future<void> _latest = Future.value();
  final _missing = <ModDownloadRecord>{};

  Future<void> load() async {
    emit(const DownloadedState.loading());
    await _refresh();
  }

  /// The failure is returned, not emitted: the list stays on screen. A
  /// success resolves after the refreshed list was emitted.
  Future<Either<Failure, Unit>> delete(ModDownloadRecord r) async {
    final result = await _repository.delete(r);
    if (!isClosed && result.isRight()) await _refresh();
    return result;
  }

  Future<Either<Failure, ImportOutcome>> importToGame(ModDownloadRecord r) =>
      _repository.importToGame(r);

  /// Import found the file gone: flag [r] (a re-download makes a new record,
  /// so the flag drops on its own).
  Future<void> markMissing(ModDownloadRecord r) {
    _missing.add(r);
    return _refresh();
  }

  /// Silent: never emits loading. A superseded refresh resolves with the
  /// newest one, so awaiting it always means "the list is current".
  Future<void> _refresh() => _latest = _doRefresh(++_seq);

  Future<void> _doRefresh(int seq) async {
    final result = await _repository.list();
    if (isClosed) return;
    if (seq != _seq) return _latest;
    emit(
      result.fold(
        DownloadedState.failure,
        // list() is newest first.
        (records) => DownloadedState.success(
          records: records,
          totalBytes: records.fold(0, (sum, r) => sum + r.sizeBytes),
          missingIds: {
            for (final r in records)
              if (_missing.contains(r)) r.sourceId,
          },
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
