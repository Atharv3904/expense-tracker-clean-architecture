import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository profileRepository;

  const GetProfileUsecase(this.profileRepository);

  Future<Either<ProfileFailure, ProfileEntity>> call() async {
    return profileRepository.getProfile();
  }
}
