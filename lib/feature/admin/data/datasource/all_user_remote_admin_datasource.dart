import 'package:expense_tracker/feature/admin/data/model/all_user_model.dart';

abstract class AllUserRemoteAdminDatasource {
  Future<List<AllUserModel>> getAllUsers();
}
