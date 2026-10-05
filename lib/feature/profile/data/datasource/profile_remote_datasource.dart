import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/params/update_profile_params.dart';

abstract class ProfileRemoteDatasource {
  Future<void> updateProfile(UpdateProfileParams params);
  Future<void> changePassword(String password);

  Future<ProfileEntity> getProfile();
}
