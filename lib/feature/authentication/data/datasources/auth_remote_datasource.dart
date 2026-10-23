import 'package:expense_tracker/feature/authentication/data/models/user_model.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> registerUser(RegisterParams params);

  Future<UserModel> loginUser(LoginParams params);

  Future<UserModel?> getCurrentUser();

  Future<void> logout();

  Future<void> forgotPassword(ForgotPasswordParams email);

  Future<void> updatePassword(UpdatePasswordParams params);
}
