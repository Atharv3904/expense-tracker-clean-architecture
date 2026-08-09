import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, AuthUserEntity>> registerUser(
    RegisterParams params,
  );

  Future<Either<AppFailure, AuthUserEntity>> loginUser(LoginParams params);

  Future<Either<AppFailure, AuthUserEntity?>> getCurrentUser();

  Future<Either<AppFailure, void>> logout();
}
