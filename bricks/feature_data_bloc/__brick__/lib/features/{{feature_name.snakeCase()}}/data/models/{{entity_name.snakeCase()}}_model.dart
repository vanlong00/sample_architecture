import 'package:freezed_annotation/freezed_annotation.dart';

part '{{entity_name.snakeCase()}}_model.freezed.dart';
part '{{entity_name.snakeCase()}}_model.g.dart';

@freezed
abstract class {{entity_name.pascalCase()}} with _${{entity_name.pascalCase()}} {
  const factory {{entity_name.pascalCase()}}({
    required int id,
    required String name,
  }) = _{{entity_name.pascalCase()}};

  factory {{entity_name.pascalCase()}}.fromJson(Map<String, dynamic> json) =>
      _${{entity_name.pascalCase()}}FromJson(json);
}
