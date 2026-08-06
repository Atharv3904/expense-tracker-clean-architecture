class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}
