import 'package:json_annotation/json_annotation.dart';

/// Server values (risk R1: confirm against the real `mods.type` enum).
enum ModType {
  @JsonValue('bus')
  bus,
  @JsonValue('truck')
  truck,
  @JsonValue('car')
  car,
  @JsonValue('map')
  map;

  /// Value sent as the `type` query param (same as the JSON value).
  String get apiValue => name;
}

enum ModSort {
  popular,
  newest;

  String get apiValue => name;
}
