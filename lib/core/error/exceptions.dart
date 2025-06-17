class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() {
    return 'CacheException: $message';
  }
}
