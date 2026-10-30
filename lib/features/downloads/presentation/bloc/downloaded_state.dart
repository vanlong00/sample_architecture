import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_download_record.dart';

part 'downloaded_state.freezed.dart';

@freezed
sealed class DownloadedState with _$DownloadedState {
  const factory DownloadedState.initial() = DownloadedInitial;
  const factory DownloadedState.loading() = DownloadedLoading;
  const factory DownloadedState.success({
    required List<ModDownloadRecord> records,
    required int totalBytes,

    /// Records whose file was found missing when importing.
    @Default(<int>{}) Set<int> missingIds,
  }) = DownloadedSuccess;
  const factory DownloadedState.failure(Failure failure) = DownloadedFailure;
}
