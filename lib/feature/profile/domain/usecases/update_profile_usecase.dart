import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository profileRepository;
  const UpdateProfileUsecase(this.profileRepository);

  Future<void> call({required String name}) async {
    return profileRepository.updateProfile(name: name);
  }
}
