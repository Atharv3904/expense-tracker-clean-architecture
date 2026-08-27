import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ChangePasswordUsecase {
  final ProfileRepository profileRepository;

  ChangePasswordUsecase(this.profileRepository);

  Future<Either<ProfileFailure, void>> call({required String password}) {
    return profileRepository.changePassword(password: password);
  }
}
