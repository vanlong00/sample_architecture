import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart';

class MockRemote extends Mock implements {{feature_name.pascalCase()}}RemoteDataSource {}

void main() {
  late MockRemote remote;
  late {{feature_name.pascalCase()}}Repository repo;

  setUp(() {
    remote = MockRemote();
    repo = {{feature_name.pascalCase()}}RepositoryImpl(remote);
  });

  test('thành công → Right chứa danh sách', () async {
    when(() => remote.get{{feature_name.pascalCase()}}()).thenAnswer(
      (_) async => const [{{entity_name.pascalCase()}}(id: 1, name: 'n')],
    );
    final result = await repo.fetch{{feature_name.pascalCase()}}();
    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected Right'), (list) {
      expect(list, hasLength(1));
      expect(list.first.id, 1);
    });
  });

  test('DioException(Unauthorized) → Left(unauthorized)', () async {
    when(() => remote.get{{feature_name.pascalCase()}}()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/{{feature_name.paramCase()}}'),
        error: UnauthorizedException(),
      ),
    );
    final result = await repo.fetch{{feature_name.pascalCase()}}();
    expect(
      result,
      equals(left<Failure, List<{{entity_name.pascalCase()}}>>(const Failure.unauthorized())),
    );
  });
}
