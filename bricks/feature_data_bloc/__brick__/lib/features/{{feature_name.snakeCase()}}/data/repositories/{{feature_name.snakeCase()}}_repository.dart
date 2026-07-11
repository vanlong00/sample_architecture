import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';
import '../models/{{entity_name.snakeCase()}}_model.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  Future<Either<Failure, List<{{entity_name.pascalCase()}}>>> fetch{{feature_name.pascalCase()}}();
}

@LazySingleton(as: {{feature_name.pascalCase()}}Repository)
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl(this._remote);

  final {{feature_name.pascalCase()}}RemoteDataSource _remote;

  @override
  Future<Either<Failure, List<{{entity_name.pascalCase()}}>>> fetch{{feature_name.pascalCase()}}() =>
      guard(() => _remote.get{{feature_name.pascalCase()}}());
}
