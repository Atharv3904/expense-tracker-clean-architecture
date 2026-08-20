import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);
}

class ProfileSuccess extends ProfileState {
  final String message;

  const ProfileSuccess(this.message);
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
