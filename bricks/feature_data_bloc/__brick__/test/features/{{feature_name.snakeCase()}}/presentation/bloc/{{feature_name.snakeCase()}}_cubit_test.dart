import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_state.dart';

class MockRepo extends Mock implements {{feature_name.pascalCase()}}Repository {}

void main() {
  late MockRepo repo;

  setUp(() => repo = MockRepo());

  blocTest<{{feature_name.pascalCase()}}Cubit, {{feature_name.pascalCase()}}State>(
    'load thành công → [loading, success]',
    build: () {
      when(() => repo.fetch{{feature_name.pascalCase()}}()).thenAnswer(
        (_) async => right(const [{{entity_name.pascalCase()}}(id: 1, name: 'n')]),
      );
      return {{feature_name.pascalCase()}}Cubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const {{feature_name.pascalCase()}}State.loading(),
      const {{feature_name.pascalCase()}}State.success([{{entity_name.pascalCase()}}(id: 1, name: 'n')]),
    ],
  );

  blocTest<{{feature_name.pascalCase()}}Cubit, {{feature_name.pascalCase()}}State>(
    'load lỗi → [loading, failure]',
    build: () {
      when(() => repo.fetch{{feature_name.pascalCase()}}()).thenAnswer(
        (_) async => left(const Failure.network()),
      );
      return {{feature_name.pascalCase()}}Cubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const {{feature_name.pascalCase()}}State.loading(),
      const {{feature_name.pascalCase()}}State.failure(Failure.network()),
    ],
  );
}
