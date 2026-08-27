import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository profileRepository;
  const UpdateProfileUsecase(this.profileRepository);

  Future<Either<ProfileFailure, void>> call({required String name}) async {
    return profileRepository.updateProfile(name: name);
  }
}
