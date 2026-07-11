import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'exceptions.dart';
import 'failure.dart';

Future<Either<Failure, T>> guard<T>(Future<T> Function() body) async {
  try {
    final result = await body();
    return right(result);
  } on DioException catch (e) {
    return left(_fromError(e.error));
  } on ServerException catch (e) {
    return left(Failure.server(message: e.message, code: e.code));
  } on UnauthorizedException {
    return left(const Failure.unauthorized());
  } on NetworkException {
    return left(const Failure.network());
  } on CacheException {
    return left(const Failure.cache());
  } catch (e) {
    return left(Failure.unknown(e.toString()));
  }
}

// NOTE: keep this mapping in sync with the direct `on ...Exception` catches
// in `guard` above — both translate the same Exception types to Failure.
Failure _fromError(Object? error) {
  if (error is UnauthorizedException) return const Failure.unauthorized();
  if (error is NetworkException) return const Failure.network();
  if (error is ServerException) {
    return Failure.server(message: error.message, code: error.code);
  }
  return Failure.unknown(error?.toString());
}
