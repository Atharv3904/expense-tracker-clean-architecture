class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException implements AppException {
  @override
  final String message;

  ServerException(this.message);
}

class ProfileException implements AppException {
  @override
  final String message;

  ProfileException(this.message);
}

class CategoryException implements AppException {
  @override
  final String message;
  CategoryException(this.message);
}

class TypeException implements AppException {
  @override
  final String message;
  TypeException(this.message);
}

class ReminderException implements AppException {
  @override
  final String message;
  ReminderException(this.message);
}
