import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../mods/data/models/mod_type.dart';

part 'mod_download_record.freezed.dart';
part 'mod_download_record.g.dart';

/// One downloaded mod file on disk, keyed by `sourceId` (one file per mod).
/// [relPath] is relative to the app support dir: `mods/<sourceId>.<ext>`.
@freezed
abstract class ModDownloadRecord with _$ModDownloadRecord {
  const factory ModDownloadRecord({
    required int sourceId,
    required String title,
    String? thumbUrl,
    required ModType type,
    required String relPath,
    required int sizeBytes,
    required int createdAtMs,
  }) = _ModDownloadRecord;

  factory ModDownloadRecord.fromJson(Map<String, dynamic> json) =>
      _$ModDownloadRecordFromJson(json);
}

extension ModDownloadRecordX on ModDownloadRecord {
  /// Extension of [relPath] with its original case (no dot).
  String get extension => relPath.substring(relPath.lastIndexOf('.') + 1);

  String get key => sourceId.toString();
}
