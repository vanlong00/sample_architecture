// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilterOption _$FilterOptionFromJson(Map<String, dynamic> json) =>
    _FilterOption(
      id: json['_id'] as String,
      name: json['name'] as String,
      modCount:
          (json['modCount'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
    );

Map<String, dynamic> _$FilterOptionToJson(_FilterOption instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'modCount': instance.modCount,
    };
