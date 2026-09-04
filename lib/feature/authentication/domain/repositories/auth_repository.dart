import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';

abstract class AuthRepository {
  AppResult<AuthUserEntity> registerUser(RegisterParams params);

  AppResult<AuthUserEntity> loginUser(LoginParams params);

  AppResult<AuthUserEntity?> getCurrentUser();

  AppResult<void> logout();

  AppResult<void> forgotPassword(ForgotPasswordParams email);
}
