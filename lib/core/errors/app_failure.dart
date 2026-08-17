class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message);
}
