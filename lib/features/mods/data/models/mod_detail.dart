import 'package:freezed_annotation/freezed_annotation.dart';

import 'mod_card.dart';
import 'mod_type.dart';

part 'mod_detail.freezed.dart';
part 'mod_detail.g.dart';

@freezed
abstract class ModDetail with _$ModDetail {
  const factory ModDetail({
    required int sourceId,
    required ModType type,
    required String title,
    ModMedia? media,
    ModDownload? download,
    ModRef? manufacturer,
    ModRef? category,
    ModRef? country,
    ModStats? stats,
    @Default(<ModSpec>[]) List<ModSpec> specs,
    String? contentHtml,
  }) = _ModDetail;

  factory ModDetail.fromJson(Map<String, dynamic> json) =>
      _$ModDetailFromJson(json);
}

@freezed
abstract class ModSpec with _$ModSpec {
  const factory ModSpec({
    required String group,
    required String label,
    required String value,
  }) = _ModSpec;

  factory ModSpec.fromJson(Map<String, dynamic> json) =>
      _$ModSpecFromJson(json);
}

extension ModDetailX on ModDetail {
  bool get isDownloadable => download.isMirrored;
  String? get thumbnail => media?.thumbnail;
}

/// Groups [specs] by `group`, keeping first-seen group order.
List<(String group, List<ModSpec>)> groupSpecs(List<ModSpec> specs) {
  final groups =
      <String, List<ModSpec>>{}; // LinkedHashMap keeps insertion order
  for (final s in specs) {
    (groups[s.group] ??= []).add(s);
  }
  return [for (final e in groups.entries) (e.key, e.value)];
}
