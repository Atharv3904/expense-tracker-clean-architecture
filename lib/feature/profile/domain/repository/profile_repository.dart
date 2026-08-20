import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<void> updateProfile({required String name});
  Future<void> changePassword({required String password});
}
