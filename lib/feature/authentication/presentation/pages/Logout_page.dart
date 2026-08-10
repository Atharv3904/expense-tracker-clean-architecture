import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LogoutCubit>(),
      child: BlocListener<LogoutCubit, LogoutState>(
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
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<LogoutCubit>().logout();
                  },
                  child: Text("Logout"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
