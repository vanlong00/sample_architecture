import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_version_model.freezed.dart';
part 'data_version_model.g.dart';

/// Server data version (`GET /data-version`). `0` means never bumped.
@freezed
abstract class DataVersionModel with _$DataVersionModel {
  const factory DataVersionModel({required int version}) = _DataVersionModel;

  factory DataVersionModel.fromJson(Map<String, dynamic> json) =>
      _$DataVersionModelFromJson(json);
}
