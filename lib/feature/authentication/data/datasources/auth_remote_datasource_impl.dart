import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/data/models/user_model.dart';
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
}
