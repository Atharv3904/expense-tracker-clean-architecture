import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          AppSnackbar.show(context, message: "Registration Successful");

          context.go(RoutesName.login);
        }

        if (state is RegisterFailure) {
          AppSnackbar.show(context, message: state.message);
        }
      },
      child: const Scaffold(
        backgroundColor: _RegisterPalette.bg,
        body: SafeArea(child: RegisterForm()),
      ),
    );
  }
}

class _RegisterPalette {
  static const bg = Color(0xFFF3F6F4);
}
