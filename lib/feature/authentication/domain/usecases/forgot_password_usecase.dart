import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;
  const ForgotPasswordUsecase(this.repository);

  AppResult<void> call(ForgotPasswordParams email) async {
    return await repository.forgotPassword(email);
  }
}
