import 'package:expense_tracker/feature/authentication/data/models/user_model.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';

abstract class AuthRemoteDatasource {
  Future<AuthUserEntity> registerUser(RegisterParams params);
  Future<AuthUserEntity> loginUser(LoginParams param);

  UserModel? getCurrentUser();

  Future<void> logout();
  Future<void> forgotPassword(ForgotPasswordParams email);
}
