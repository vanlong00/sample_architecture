// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mod_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModDetail _$ModDetailFromJson(Map<String, dynamic> json) => _ModDetail(
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
  specs:
      (json['specs'] as List<dynamic>?)
          ?.map((e) => ModSpec.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ModSpec>[],
  contentHtml: json['contentHtml'] as String?,
);

Map<String, dynamic> _$ModDetailToJson(_ModDetail instance) =>
    <String, dynamic>{
      'sourceId': instance.sourceId,
      'type': _$ModTypeEnumMap[instance.type]!,
      'title': instance.title,
      'media': instance.media,
      'download': instance.download,
      'manufacturer': instance.manufacturer,
      'category': instance.category,
      'country': instance.country,
      'stats': instance.stats,
      'specs': instance.specs,
      'contentHtml': instance.contentHtml,
    };

const _$ModTypeEnumMap = {
  ModType.bus: 'bus',
  ModType.truck: 'truck',
  ModType.car: 'car',
  ModType.map: 'map',
};

_ModSpec _$ModSpecFromJson(Map<String, dynamic> json) => _ModSpec(
  group: json['group'] as String,
  label: json['label'] as String,
  value: json['value'] as String,
);

Map<String, dynamic> _$ModSpecToJson(_ModSpec instance) => <String, dynamic>{
  'group': instance.group,
  'label': instance.label,
  'value': instance.value,
};
