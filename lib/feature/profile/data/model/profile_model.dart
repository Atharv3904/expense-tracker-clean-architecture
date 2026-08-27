import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory ProfileModel.fronJson(Map<String, dynamic> json, {String? email}) {
    return ProfileModel(
      name: json['name'] as String?,
      email: email ?? '',
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
