import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<void> updateProfile(String name) async {
    await supabaseClient.auth.updateUser(UserAttributes(data: {'name': name}));
  }

  @override
  Future<void> changePassword(String password) async {
    await supabaseClient.auth.updateUser(UserAttributes(password: password));
  }

  @override
  Future<User> getProfile() async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }
    return user;
  }
}
