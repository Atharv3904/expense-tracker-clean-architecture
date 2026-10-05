import 'package:file_picker/file_picker.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final PlatformFile? avatar;

  const UpdateProfile({required this.name, this.avatar});
}

class ChangePassword extends ProfileEvent {
  final String password;

  const ChangePassword(this.password);
}
