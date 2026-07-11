import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/data/repositories/articles_repository.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_cubit.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_state.dart';

class MockRepo extends Mock implements ArticlesRepository {}

void main() {
  late MockRepo repo;

  setUp(() => repo = MockRepo());

  blocTest<ArticlesCubit, ArticlesState>(
    'load thành công → [loading, success]',
    build: () {
      when(() => repo.fetchArticles()).thenAnswer(
        (_) async => right(const [Article(id: 1, title: 't', body: 'b')]),
      );
      return ArticlesCubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const ArticlesState.loading(),
      const ArticlesState.success([Article(id: 1, title: 't', body: 'b')]),
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'load lỗi → [loading, failure]',
    build: () {
      when(() => repo.fetchArticles()).thenAnswer(
        (_) async => left(const Failure.network()),
      );
      return ArticlesCubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const ArticlesState.loading(),
      const ArticlesState.failure(Failure.network()),
    ],
  );
}
