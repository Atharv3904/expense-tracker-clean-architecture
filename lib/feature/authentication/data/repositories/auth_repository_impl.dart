// ignore_for_file: unused_catch_clause

import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
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
      return Left(AppFailure("wrong email and password please check , again"));
    } catch (_) {
      return Left(AppFailure("check your net"));
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
      return Left(AppFailure("wrong email and password please check , again"));
    } catch (_) {
      return Left(AppFailure("check your net"));
    }
  }

  @override
  Future<Either<AppFailure, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = remoteDataSource.getCurrentUser();
      return Right(user);
    } on AppException catch (e) {
      return const Left(AuthFailure("we are unable to fetch user"));
    } catch (_) {
      return Left(AppFailure("check your net"));
    }
  }

  @override
  Future<Either<AppFailure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on AppException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return Left(AuthFailure("Logout_failed"));
    }
  }

  @override
  Future<Either<AppFailure, void>> forgotPassword(
    ForgotPasswordParams email,
  ) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return Right(null);
    } on AppException catch (exception) {
      return Left(AppFailure(exception.message));
    } catch (_) {
      return Left(AppFailure("Unable to reset password"));
    }
  }
}
