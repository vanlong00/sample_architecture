import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../downloads/data/logic/mod_file.dart';
import 'mod_type.dart';

part 'mod_card.freezed.dart';
part 'mod_card.g.dart';

@freezed
abstract class ModCard with _$ModCard {
  const factory ModCard({
    required int sourceId,
    required ModType type,
    required String title,
    ModMedia? media,
    ModDownload? download,
    ModRef? manufacturer,
    ModRef? category,
    ModRef? country,
    ModStats? stats,
  }) = _ModCard;

  factory ModCard.fromJson(Map<String, dynamic> json) =>
      _$ModCardFromJson(json);
}

@freezed
abstract class ModMedia with _$ModMedia {
  const factory ModMedia({
    String? thumbnail,
    @Default(<String>[]) List<String> images,
  }) = _ModMedia;

  factory ModMedia.fromJson(Map<String, dynamic> json) =>
      _$ModMediaFromJson(json);
}

@freezed
abstract class ModStats with _$ModStats {
  const factory ModStats({int? downloads}) = _ModStats;

  factory ModStats.fromJson(Map<String, dynamic> json) =>
      _$ModStatsFromJson(json);
}

@freezed
abstract class ModRef with _$ModRef {
  const factory ModRef({
    @JsonKey(name: '_id') required String id,
    String? name,
  }) = _ModRef;

  factory ModRef.fromJson(Map<String, dynamic> json) => _$ModRefFromJson(json);
}

/// F1: deliberately NO `url` field (the third-party source link). The app may
/// only ever download from the mirrored [storageUrl].
@freezed
abstract class ModDownload with _$ModDownload {
  const factory ModDownload({
    String? storageUrl,
    int? sizeBytes,
    String? fileFormat,
  }) = _ModDownload;

  factory ModDownload.fromJson(Map<String, dynamic> json) =>
      _$ModDownloadFromJson(json);
}

extension ModCardX on ModCard {
  bool get isDownloadable => download.isMirrored;
  String? get thumbnail => media?.thumbnail;
}

extension ModDownloadX on ModDownload? {
  /// Same rule as the download (F1/F2/F3): [isAllowedStorageUrl].
  bool get isMirrored => isAllowedStorageUrl(this?.storageUrl);
}
