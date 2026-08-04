import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends AuthUserEntity {
  UserModel({required super.id, required super.email});

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(id: user.id, email: user.email ?? '');
  }
}
