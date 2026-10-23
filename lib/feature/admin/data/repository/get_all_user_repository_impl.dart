import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/admin/data/datasource/all_user_remote_admin_datasource.dart';
import 'package:expense_tracker/feature/admin/domain/entity/all_user_entity.dart';
import 'package:expense_tracker/feature/admin/domain/repository/all_user_repository.dart';

class GetAllUserRepositoryImpl implements AllUserRepository {
  final AllUserRemoteAdminDatasource _allUserRemoteAdminDatasource;

  GetAllUserRepositoryImpl(this._allUserRemoteAdminDatasource);

  @override
  AppResult<List<AllUserEntity>> getAllUsers() async {
    try {
      final result = await _allUserRemoteAdminDatasource.getAllUsers();

      return Right(result);
    } on AppException catch (exception) {
      return Left(AppFailure(exception.message));
    } catch (_) {
      return Left(AppFailure('Unable to fetch users'));
    }
  }
}
