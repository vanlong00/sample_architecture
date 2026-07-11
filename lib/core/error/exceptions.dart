class ServerException implements Exception {
  ServerException({this.message, this.code});
  final String? message;
  final int? code;
}

class CacheException implements Exception {}

class UnauthorizedException implements Exception {}

class NetworkException implements Exception {}
