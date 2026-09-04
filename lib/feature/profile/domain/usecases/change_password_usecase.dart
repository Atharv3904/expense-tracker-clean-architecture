import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ChangePasswordUsecase {
  final ProfileRepository profileRepository;

  ChangePasswordUsecase(this.profileRepository);

  AppResult<void> call({required String password}) {
    return profileRepository.changePassword(password: password);
  }
}
