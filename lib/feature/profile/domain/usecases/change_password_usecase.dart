import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ChangePasswordUsecase {
  final ProfileRepository profileRepository;

  ChangePasswordUsecase(this.profileRepository);

  Future<void> call({required String password}) {
    return profileRepository.changePassword(password: password);
  }
}
