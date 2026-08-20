abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;

  const UpdateProfile(this.name);
}

class ChangePassword extends ProfileEvent {
  final String password;

  const ChangePassword(this.password);
}
