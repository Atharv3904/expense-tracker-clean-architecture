import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

abstract class ProfileRemoteDatasource {
  Future<void> updateProfile(String name);
  Future<void> changePassword(String password);

  Future<ProfileEntity> getProfile();
}
