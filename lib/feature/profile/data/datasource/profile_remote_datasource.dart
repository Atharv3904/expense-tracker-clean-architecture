import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<void> updateProfile(String name);
  Future<void> changePassword(String password);

  Future<User> getProfile();
}
