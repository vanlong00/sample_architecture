import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/{{entity_name.snakeCase()}}_model.dart';

part '{{feature_name.snakeCase()}}_state.freezed.dart';

@freezed
sealed class {{feature_name.pascalCase()}}State with _${{feature_name.pascalCase()}}State {
  const factory {{feature_name.pascalCase()}}State.initial() = {{feature_name.pascalCase()}}Initial;
  const factory {{feature_name.pascalCase()}}State.loading() = {{feature_name.pascalCase()}}Loading;
  const factory {{feature_name.pascalCase()}}State.success(List<{{entity_name.pascalCase()}}> items) = {{feature_name.pascalCase()}}Success;
  const factory {{feature_name.pascalCase()}}State.failure(Failure failure) = {{feature_name.pascalCase()}}Failure;
}
