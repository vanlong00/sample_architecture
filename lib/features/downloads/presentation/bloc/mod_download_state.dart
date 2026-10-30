import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_download_record.dart';

part 'mod_download_state.freezed.dart';

@freezed
sealed class ModDownloadState with _$ModDownloadState {
  /// Initial: the stored/running state is not resolved yet; the CTA must not
  /// offer Download.
  const factory ModDownloadState.checking() = ModDownloadChecking;
  const factory ModDownloadState.idle() = ModDownloadIdle;

  /// [total] is -1 when the server sent no Content-Length.
  const factory ModDownloadState.downloading({
    required int received,
    required int total,
  }) = ModDownloadDownloading;
  const factory ModDownloadState.downloaded(ModDownloadRecord record) =
      ModDownloadDownloaded;

  /// A record exists but its file is gone from disk.
  const factory ModDownloadState.fileMissing(ModDownloadRecord record) =
      ModDownloadFileMissing;

  /// A download attempt failed: Retry starts it again. [previous] is the
  /// earlier copy (record + file still on disk) of a failed re-download, so
  /// the UI can keep offering Import; `null` for a failed first download.
  const factory ModDownloadState.failure(
    Failure failure, [
    ModDownloadRecord? previous,
  ]) = ModDownloadFailure;

  /// Reading the stored state failed: Retry re-checks, never downloads.
  const factory ModDownloadState.checkFailure(Failure failure) =
      ModDownloadCheckFailure;
}
