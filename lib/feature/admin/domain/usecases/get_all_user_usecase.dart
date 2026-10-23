import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/admin/domain/entity/all_user_entity.dart';
import 'package:expense_tracker/feature/admin/domain/repository/all_user_repository.dart';

class GetAllUserUsecase {
  final AllUserRepository _allUserRepository;

  GetAllUserUsecase(this._allUserRepository);

  AppResult<List<AllUserEntity>> call() {
    return _allUserRepository.getAllUsers();
  }
}
