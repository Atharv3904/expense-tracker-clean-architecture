import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<ProfileFailure, ProfileEntity>> getProfile();
  Future<Either<ProfileFailure, void>> updateProfile({required String name});
  Future<Either<ProfileFailure, void>> changePassword({
    required String password,
  });
}
