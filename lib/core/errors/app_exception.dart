class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class ProfileException implements Exception {
  final String message;

  ProfileException(this.message);
}

class CategoryException implements Exception {
  final String message;
  CategoryException(this.message);
}

class TypeException implements Exception {
  final String message;
  TypeException(this.message);
}
