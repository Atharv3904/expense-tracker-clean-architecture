import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/params/update_profile_params.dart';

abstract class ProfileRepository {
  AppResult<ProfileEntity> getProfile();
  AppResult<void> updateProfile(UpdateProfileParams params);
  AppResult<void> changePassword({required String password});
}
