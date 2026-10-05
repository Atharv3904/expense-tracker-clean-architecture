import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/data/model/profile_model.dart';
import 'package:expense_tracker/feature/profile/domain/params/update_profile_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<void> updateProfile(UpdateProfileParams params) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ProfileException('User not logged in');
    }

    try {
      String? avatarPath;

      // Upload avatar if a new image was selected.
      if (params.avatar != null) {
        final avatar = params.avatar!;

        final imageBytes = await avatar.readAsBytes();

        avatarPath = '${user.id}/profile.jpg';

        await supabaseClient.storage
            .from('avatars')
            .uploadBinary(
              avatarPath,
              imageBytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: true,
              ),
            );
      }

      // Update profile information.
      final updateData = <String, dynamic>{
        'name': params.name,
        'updated_at': DateTime.now().toIso8601String(),
        'updated_by': user.id,
      };

      // Only update avatar_path when a new avatar was selected.
      if (avatarPath != null) {
        updateData['avatar_path'] = avatarPath;
      }

      await supabaseClient
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);
    } on StorageException catch (e) {
      throw ProfileException(e.message);
    } on PostgrestException catch (e) {
      throw ProfileException(e.message);
    } catch (e) {
      if (e is ProfileException) {
        rethrow;
      }

      throw ProfileException('Failed to update profile');
    }
  }

  @override
  Future<void> changePassword(String password) async {
    try {
      await supabaseClient.auth.updateUser(UserAttributes(password: password));
    } catch (e) {
      throw ProfileException('Password is not changed');
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
          .select('id, name, avatar_path')
          .eq('id', user.id)
          .single();

      final avatarPath = response['avatar_path'] as String?;

      String? avatarUrl;

      if (avatarPath != null && avatarPath.isNotEmpty) {
        avatarUrl = await supabaseClient.storage
            .from('avatars')
            .createSignedUrl(avatarPath, 60 * 60);
      }

      return ProfileModel.fromJson(
        response,
        email: user.email,
        avatarUrl: avatarUrl,
      );
    } on StorageException catch (e) {
      throw ProfileException(e.message);
    } on PostgrestException catch (e) {
      throw ProfileException(e.message);
    } catch (e) {
      if (e is ProfileException) {
        rethrow;
      }

      throw ProfileException('Failed to get profile');
    }
  }
}
