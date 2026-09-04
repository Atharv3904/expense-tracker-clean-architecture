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

class ReminderFailure extends AppFailure {
  const ReminderFailure(super.message);
}

class SharedPrefFailure extends AppFailure {
  const SharedPrefFailure(super.message);
}
