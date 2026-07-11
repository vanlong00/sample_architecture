import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/articles/data/datasources/articles_remote_datasource.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/data/repositories/articles_repository.dart';

class MockRemote extends Mock implements ArticlesRemoteDataSource {}

void main() {
  late MockRemote remote;
  late ArticlesRepository repo;

  setUp(() {
    remote = MockRemote();
    repo = ArticlesRepositoryImpl(remote);
  });

  test('thành công → Right chứa danh sách', () async {
    when(() => remote.getArticles()).thenAnswer(
      (_) async => const [Article(id: 1, title: 't', body: 'b')],
    );
    final result = await repo.fetchArticles();
    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected Right'), (list) {
      expect(list, hasLength(1));
      expect(list.first.id, 1);
    });
  });

  test('DioException(Unauthorized) → Left(unauthorized)', () async {
    when(() => remote.getArticles()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/articles'),
        error: UnauthorizedException(),
      ),
    );
    final result = await repo.fetchArticles();
    expect(result, equals(left<Failure, List<Article>>(const Failure.unauthorized())));
  });
}
