import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../mods/data/models/mod_detail.dart';
import '../../../mods/data/models/mod_type.dart';

part 'favorite_record.freezed.dart';
part 'favorite_record.g.dart';

/// Snapshot of a mod saved as favorite; enough to render the list offline.
@freezed
abstract class FavoriteRecord with _$FavoriteRecord {
  const factory FavoriteRecord({
    required int sourceId,
    required String title,
    String? thumbUrl,
    required ModType type,
    required int savedAtMs,
  }) = _FavoriteRecord;

  factory FavoriteRecord.of(ModDetail mod, {required int savedAtMs}) =>
      FavoriteRecord(
        sourceId: mod.sourceId,
        title: mod.title,
        thumbUrl: mod.thumbnail,
        type: mod.type,
        savedAtMs: savedAtMs,
      );

  factory FavoriteRecord.fromJson(Map<String, dynamic> json) =>
      _$FavoriteRecordFromJson(json);
}
