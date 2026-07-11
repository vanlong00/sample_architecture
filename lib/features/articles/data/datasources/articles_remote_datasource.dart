import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/article_model.dart';

part 'articles_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class ArticlesRemoteDataSource {
  @factoryMethod
  factory ArticlesRemoteDataSource(Dio dio) = _ArticlesRemoteDataSource;

  @GET('/articles')
  Future<List<Article>> getArticles();
}
