import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  AppResult<void> call() {
    return repository.logout();
  }
}
