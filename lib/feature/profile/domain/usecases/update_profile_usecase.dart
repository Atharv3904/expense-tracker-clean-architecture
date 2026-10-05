import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/profile/domain/params/update_profile_params.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  const UpdateProfileUsecase(this.repository);

  AppResult<void> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params);
  }
}
