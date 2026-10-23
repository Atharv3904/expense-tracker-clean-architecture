import 'package:expense_tracker/feature/authentication/domain/entities/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends AuthUserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
  });

  factory UserModel.fromSupabaseUser(User user, {required String role}) {
    return UserModel(id: user.id, email: user.email ?? '', role: role);
  }
}
