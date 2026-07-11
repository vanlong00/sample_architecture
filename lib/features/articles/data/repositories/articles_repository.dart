import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../datasources/articles_remote_datasource.dart';
import '../models/article_model.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> fetchArticles();
}

@LazySingleton(as: ArticlesRepository)
class ArticlesRepositoryImpl implements ArticlesRepository {
  ArticlesRepositoryImpl(this._remote);

  final ArticlesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Article>>> fetchArticles() =>
      guard(() => _remote.getArticles());
}
