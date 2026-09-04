import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository profileRepository;

  const GetProfileUsecase(this.profileRepository);

  AppResult<ProfileEntity> call() async {
    return profileRepository.getProfile();
  }
}
