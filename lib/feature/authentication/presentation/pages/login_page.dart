import 'package:expense_tracker/core/notification/device_token_service.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _LoginPagePalette {
  static const bg = Color(0xFFF3F6F4);
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          AppSnackbar.show(context, message: "Login Successful");

          await DeviceTokenService().saveToken();

          if (context.mounted) {
            context.pushReplacement(RoutesName.mainNavigationPage);
          }
        }

        if (state is LoginFailure) {
          if (context.mounted) {
            AppSnackbar.show(context, message: state.message);
          }
        }
      },
      child: Scaffold(
        backgroundColor: _LoginPagePalette.bg,
        body: SafeArea(child: LoginForm()),
      ),
    );
  }
}
