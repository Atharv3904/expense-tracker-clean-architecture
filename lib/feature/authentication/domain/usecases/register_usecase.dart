import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<AppFailure, AuthUserEntity>> call(RegisterParams params) async {
    final result = await repository.registerUser(params);
    return result;
  }
}

//this data comes from user using Bloc and then it is passed to the repository
  // which will handle the data and send it to the data layer
  //beacuse we will implement the domain repo in data repo and then we will
  //implement the data repo in data layer
