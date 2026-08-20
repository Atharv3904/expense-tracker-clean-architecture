import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/domain/entites/profile_entity.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<ProfileEntity> getProfile() async {
    final user = await remoteDatasource.getProfile();

    return ProfileEntity(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'],
    );
  }

  @override
  Future<void> updateProfile({required String name}) async {
    await remoteDatasource.updateProfile(name);
  }

  @override
  Future<void> changePassword({required String password}) async {
    await remoteDatasource.changePassword(password);
  }
}
