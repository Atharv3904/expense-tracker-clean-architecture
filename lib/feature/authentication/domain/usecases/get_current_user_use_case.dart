import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;
  const GetCurrentUserUseCase(this.repository);

  AppResult<AuthUserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}
