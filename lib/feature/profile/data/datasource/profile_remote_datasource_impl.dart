import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/data/model/profile_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<void> updateProfile(String name) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ProfileException("user Not loged in");
    }

    final model = ProfileModel(
      id: user.id,
      name: name,
      email: user.email ?? '',
    );

    final result = model.toJson();
    try {
      await supabaseClient
          .from("profiles")
          .update({
            'name': result['name'],
            'updated_at': DateTime.now().toIso8601String(),
            'updated_by': user.id,
          })
          .eq('id', user.id);
    } catch (e) {
      throw ProfileException(e.toString());
    }
  }

  @override
  Future<void> changePassword(String password) async {
    try {
      await supabaseClient.auth.updateUser(UserAttributes(password: password));
    } catch (e) {
      throw ProfileException(e.toString());
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ProfileException('User not logged in');
    }

    try {
      final response = await supabaseClient
          .from('profiles')
          .select('id , name')
          .eq('id', user.id)
          .single();

      return ProfileModel.fronJson(response, email: user.email);
    } catch (e) {
      throw ProfileException(e.toString());
    }
  }
}
