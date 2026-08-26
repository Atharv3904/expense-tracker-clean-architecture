// ignore_for_file: annotate_overrides, file_names

import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go(RoutesName.login);
        }

        if (state is LogoutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: BlocBuilder<LogoutCubit, LogoutState>(
          builder: (context, state) {
            if (state is LogoutLoading) {
              return Center(child: const CircularProgressIndicator());
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
