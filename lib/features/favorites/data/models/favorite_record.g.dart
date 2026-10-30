// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteRecord _$FavoriteRecordFromJson(Map<String, dynamic> json) =>
    _FavoriteRecord(
      sourceId: (json['sourceId'] as num).toInt(),
      title: json['title'] as String,
      thumbUrl: json['thumbUrl'] as String?,
      type: $enumDecode(_$ModTypeEnumMap, json['type']),
      savedAtMs: (json['savedAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$FavoriteRecordToJson(_FavoriteRecord instance) =>
    <String, dynamic>{
      'sourceId': instance.sourceId,
      'title': instance.title,
      'thumbUrl': instance.thumbUrl,
      'type': _$ModTypeEnumMap[instance.type]!,
      'savedAtMs': instance.savedAtMs,
    };

const _$ModTypeEnumMap = {
  ModType.bus: 'bus',
  ModType.truck: 'truck',
  ModType.car: 'car',
  ModType.map: 'map',
};
