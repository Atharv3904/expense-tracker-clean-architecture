import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarPath,
    super.avatarUrl,
    super.role,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json, {
    String? email,
    String? avatarUrl,
  }) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: email ?? '',
      avatarPath: json['avatar_path'] as String?,
      avatarUrl: avatarUrl,
      role: json['role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatar_path': avatarPath, 'role': role};
  }
}
