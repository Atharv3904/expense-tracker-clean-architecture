class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

class ProfileFailure extends AppFailure {
  const ProfileFailure(super.message);
}

class CategoryFailure extends AppFailure {
  const CategoryFailure(super.message);
}

class TypeFailure extends AppFailure {
  const TypeFailure(super.message);
}
