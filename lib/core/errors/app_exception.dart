class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}
