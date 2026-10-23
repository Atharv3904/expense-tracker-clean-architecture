import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/admin/domain/entity/all_user_entity.dart';

abstract class AllUserRepository {
  AppResult<List<AllUserEntity>> getAllUsers();
}
