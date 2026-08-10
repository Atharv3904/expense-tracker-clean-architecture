// ignore_for_file: non_constant_identifier_names

import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/data/models/user_model.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabaseClient;
  AuthRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<UserModel> registerUser(RegisterParams params) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
      );

      if (response.user == null) {
        throw const AppException("User registration failed");
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (exception) {
      throw AppException(exception.message);
    } catch (_) {
      throw const AppException("something went wrong");
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
        throw const AppException('Login Failed');
      }

      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (exception) {
      throw AppException(exception.message);
    } catch (_) {
      throw const AppException("something went wrong");
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      return null;
    }

    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AppException(e.message);
    } catch (_) {
      throw AppException("Unable to logout");
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordParams Email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(Email.email);
    } on AuthException catch (e) {
      throw AppException(e.message);
    } catch (_) {
      throw AppException("try Again");
    }
  }
}
