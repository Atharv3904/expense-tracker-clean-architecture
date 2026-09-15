import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class UpdatePasswordUsecase {
  final AuthRepository repository;

  const UpdatePasswordUsecase(this.repository);

  AppResult<void> call(UpdatePasswordParams params) async {
    return await repository.updatePassword(params);
  }
}
