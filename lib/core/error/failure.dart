import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({String? message, int? code}) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.cache() = CacheFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.unknown([String? message]) = UnknownFailure;
}
