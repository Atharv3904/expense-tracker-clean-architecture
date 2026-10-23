import 'package:expense_tracker/feature/admin/domain/entity/all_user_entity.dart';

class AllUserModel extends AllUserEntity {
  AllUserModel({super.name, super.email, super.created, super.role});

  factory AllUserModel.fromJson(Map<String, dynamic> json) {
    return AllUserModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      created: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }
}
