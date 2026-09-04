import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

abstract class ProfileRepository {
  AppResult<ProfileEntity> getProfile();
  AppResult<void> updateProfile({required String name});
  AppResult<void> changePassword({required String password});
}
