// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mod_download_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModDownloadRecord _$ModDownloadRecordFromJson(Map<String, dynamic> json) =>
    _ModDownloadRecord(
      sourceId: (json['sourceId'] as num).toInt(),
      title: json['title'] as String,
      thumbUrl: json['thumbUrl'] as String?,
      type: $enumDecode(_$ModTypeEnumMap, json['type']),
      relPath: json['relPath'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      createdAtMs: (json['createdAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$ModDownloadRecordToJson(_ModDownloadRecord instance) =>
    <String, dynamic>{
      'sourceId': instance.sourceId,
      'title': instance.title,
      'thumbUrl': instance.thumbUrl,
      'type': _$ModTypeEnumMap[instance.type]!,
      'relPath': instance.relPath,
      'sizeBytes': instance.sizeBytes,
      'createdAtMs': instance.createdAtMs,
    };

const _$ModTypeEnumMap = {
  ModType.bus: 'bus',
  ModType.truck: 'truck',
  ModType.car: 'car',
  ModType.map: 'map',
};
