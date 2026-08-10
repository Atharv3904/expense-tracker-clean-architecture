import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;
  const ForgotPasswordUsecase(this.repository);

  Future<Either<AppFailure, void>> call(ForgotPasswordParams email) async {
    return await repository.forgotPassword(email);
  }
}
