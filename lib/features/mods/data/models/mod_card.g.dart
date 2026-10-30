// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mod_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModCard _$ModCardFromJson(Map<String, dynamic> json) => _ModCard(
  sourceId: (json['sourceId'] as num).toInt(),
  type: $enumDecode(_$ModTypeEnumMap, json['type']),
  title: json['title'] as String,
  media: json['media'] == null
      ? null
      : ModMedia.fromJson(json['media'] as Map<String, dynamic>),
  download: json['download'] == null
      ? null
      : ModDownload.fromJson(json['download'] as Map<String, dynamic>),
  manufacturer: json['manufacturer'] == null
      ? null
      : ModRef.fromJson(json['manufacturer'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : ModRef.fromJson(json['category'] as Map<String, dynamic>),
  country: json['country'] == null
      ? null
      : ModRef.fromJson(json['country'] as Map<String, dynamic>),
  stats: json['stats'] == null
      ? null
      : ModStats.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ModCardToJson(_ModCard instance) => <String, dynamic>{
  'sourceId': instance.sourceId,
  'type': _$ModTypeEnumMap[instance.type]!,
  'title': instance.title,
  'media': instance.media,
  'download': instance.download,
  'manufacturer': instance.manufacturer,
  'category': instance.category,
  'country': instance.country,
  'stats': instance.stats,
};

const _$ModTypeEnumMap = {
  ModType.bus: 'bus',
  ModType.truck: 'truck',
  ModType.car: 'car',
  ModType.map: 'map',
};

_ModMedia _$ModMediaFromJson(Map<String, dynamic> json) => _ModMedia(
  thumbnail: json['thumbnail'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ModMediaToJson(_ModMedia instance) => <String, dynamic>{
  'thumbnail': instance.thumbnail,
  'images': instance.images,
};

_ModStats _$ModStatsFromJson(Map<String, dynamic> json) =>
    _ModStats(downloads: (json['downloads'] as num?)?.toInt());

Map<String, dynamic> _$ModStatsToJson(_ModStats instance) => <String, dynamic>{
  'downloads': instance.downloads,
};

_ModRef _$ModRefFromJson(Map<String, dynamic> json) =>
    _ModRef(id: json['_id'] as String, name: json['name'] as String?);

Map<String, dynamic> _$ModRefToJson(_ModRef instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
};

_ModDownload _$ModDownloadFromJson(Map<String, dynamic> json) => _ModDownload(
  storageUrl: json['storageUrl'] as String?,
  sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
  fileFormat: json['fileFormat'] as String?,
);

Map<String, dynamic> _$ModDownloadToJson(_ModDownload instance) =>
    <String, dynamic>{
      'storageUrl': instance.storageUrl,
      'sizeBytes': instance.sizeBytes,
      'fileFormat': instance.fileFormat,
    };
