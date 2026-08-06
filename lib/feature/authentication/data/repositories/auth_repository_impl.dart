import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppFailure, AuthUserEntity>> registerUser(
    RegisterParams params,
  ) async {
    try {
      final user = await remoteDataSource.registerUser(params);
      return Right(user);
    } on AppException catch (exception) {
      return Left(AppFailure(exception.message));
    }
  }

  @override
  Future<Either<AppFailure, AuthUserEntity>> loginUser(
    LoginParams params,
  ) async {
    try {
      final user = await remoteDataSource.loginUser(params);
      return right(user);
    } on AppException catch (exception) {
      return left(AppFailure(exception.message));
    }
  }
}
