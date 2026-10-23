import 'package:expense_tracker/feature/admin/data/datasource/all_user_remote_admin_datasource.dart';
import 'package:expense_tracker/feature/admin/data/model/all_user_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AllUserRemoteAdminDatasourceImpl implements AllUserRemoteAdminDatasource {
  final SupabaseClient supabaseClient;

  AllUserRemoteAdminDatasourceImpl(this.supabaseClient);

  @override
  Future<List<AllUserModel>> getAllUsers() async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('name, email, created_at, role')
          .order('created_at', ascending: false);

      return (response as List)
          .map((user) => AllUserModel.fromJson(Map<String, dynamic>.from(user)))
          .toList();
    } catch (error) {
      rethrow;
    }
  }
}
