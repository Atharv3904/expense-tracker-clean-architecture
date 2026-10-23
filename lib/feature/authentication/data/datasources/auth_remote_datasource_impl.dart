// ignore_for_file: unused_catch_clause, non_constant_identifier_names

import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/data/models/user_model.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabaseClient;

  AuthRemoteDatasourceImpl(this.supabaseClient);

  Future<String> _getUserRole(String userId) async {
    try {
      final profile = await supabaseClient
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final role = profile['role'] as String?;

      if (role == null || role.trim().isEmpty) {
        throw const AppException('User role not found');
      }

      return role.trim();
    } on PostgrestException catch (exception) {
      throw AppException(exception.message.trim());
    }
  }

  @override
  Future<UserModel> registerUser(RegisterParams params) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
      );

      final user = response.user;

      if (user == null) {
        throw const AppException('User registration failed');
      }

      await supabaseClient
          .from('profiles')
          .update({'role': params.role})
          .eq('id', user.id);

      final role = await _getUserRole(user.id);

      return UserModel.fromSupabaseUser(user, role: role);
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } on PostgrestException catch (exception) {
      throw AppException(exception.message.trim());
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Something went wrong');
    }
  }

  @override
  Future<UserModel> loginUser(LoginParams param) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: param.email,
        password: param.password,
      );

      final user = response.user;

      if (user == null) {
        throw const AppException('Login failed');
      }

      final role = await _getUserRole(user.id);

      return UserModel.fromSupabaseUser(user, role: role);
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Something went wrong');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        return null;
      }

      final role = await _getUserRole(user.id);

      return UserModel.fromSupabaseUser(user, role: role);
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Unable to fetch current user');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } catch (_) {
      throw const AppException('Unable to logout');
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordParams email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email.email,
        redirectTo: 'spendly://reset-password',
      );
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } catch (_) {
      throw const AppException('Unable to reset password');
    }
  }

  @override
  Future<void> updatePassword(UpdatePasswordParams params) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: params.password),
      );
    } on AuthException catch (exception) {
      throw AppException(exception.message.trim());
    } catch (_) {
      throw const AppException('Unable to update password');
    }
  }
}
