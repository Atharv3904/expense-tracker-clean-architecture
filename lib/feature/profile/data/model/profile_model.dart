import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.name,
  });
}
