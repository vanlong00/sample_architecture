import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '{{feature_name.snakeCase()}}_state.dart';

@injectable
class {{feature_name.pascalCase()}}Cubit extends Cubit<{{feature_name.pascalCase()}}State> {
  {{feature_name.pascalCase()}}Cubit(this._repository) : super(const {{feature_name.pascalCase()}}State.initial());

  final {{feature_name.pascalCase()}}Repository _repository;

  Future<void> load() async {
    emit(const {{feature_name.pascalCase()}}State.loading());
    final result = await _repository.fetch{{feature_name.pascalCase()}}();
    result.fold(
      (failure) => emit({{feature_name.pascalCase()}}State.failure(failure)),
      (items) => emit({{feature_name.pascalCase()}}State.success(items)),
    );
  }
}
