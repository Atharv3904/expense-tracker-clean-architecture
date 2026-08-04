import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> registerUser(RegisterParams params);
}
