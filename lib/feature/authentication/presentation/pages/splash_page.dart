import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashCubit>()..checkAuthethication(),

      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            context.go(RoutesName.mainNavigationPage);
          }

          if (state is SplashUnauthenticated) {
            context.go(RoutesName.login);
          }
        },
        child: Scaffold(
          body: BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              if (state is SplashLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
