import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<ProfileFailure, ProfileEntity>> getProfile() async {
    try {
      final user = await remoteDatasource.getProfile();

      return Right(
        ProfileEntity(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'],
        ),
      );
    } on ProfileException catch (e) {
      return Left(ProfileFailure(e.message));
    }
  }

  @override
  Future<void> updateProfile({required String name}) async {
    await remoteDatasource.updateProfile(name);
  }

  @override
  Future<void> changePassword({required String password}) async {
    await remoteDatasource.changePassword(password);
  }
}
