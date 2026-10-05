import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/params/update_profile_params.dart';

import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  AppResult<ProfileEntity> getProfile() async {
    try {
      final profile = await remoteDatasource.getProfile();

      return Right(
        ProfileEntity(
          id: profile.id,
          email: profile.email,
          name: profile.name,
          avatarPath: profile.avatarPath,
          avatarUrl: profile.avatarUrl,
        ),
      );
    } on ProfileException catch (e) {
      return Left(ProfileFailure(e.message));
    } catch (_) {
      return Left(ProfileFailure("check your Internet..."));
    }
  }

  @override
  AppResult<void> updateProfile(UpdateProfileParams params) async {
    try {
      await remoteDatasource.updateProfile(params);

      return const Right(null);
    } on ProfileException catch (e) {
      return Left(ProfileFailure(e.message));
    } catch (_) {
      return Left(ProfileFailure("check your Internet..."));
    }
  }

  @override
  AppResult<void> changePassword({required String password}) async {
    try {
      await remoteDatasource.changePassword(password);
      return Right(null);
    } on ProfileException catch (e) {
      return Left(ProfileFailure(e.message));
    } catch (_) {
      return Left(ProfileFailure("check your Internet..."));
    }
  }
}
