import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/{{entity_name.snakeCase()}}_model.dart';

part '{{feature_name.snakeCase()}}_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  @factoryMethod
  factory {{feature_name.pascalCase()}}RemoteDataSource(Dio dio) = _{{feature_name.pascalCase()}}RemoteDataSource;

  @GET('/{{feature_name.paramCase()}}')
  Future<List<{{entity_name.pascalCase()}}>> get{{feature_name.pascalCase()}}();
}
