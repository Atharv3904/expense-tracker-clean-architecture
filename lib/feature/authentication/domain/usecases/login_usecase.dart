import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;
  const LoginUsecase(this.repository);

  AppResult<AuthUserEntity> call(LoginParams params) async {
    return await repository.loginUser(params);
  }
}
