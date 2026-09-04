// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/notification/device_token_service.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _SplashPalette {
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is SplashAuthenticated) {
          final deviceTokenService = DeviceTokenService();

          await deviceTokenService.saveToken();
          deviceTokenService.listenForTokenRefresh();

          if (context.mounted) {
            context.go(RoutesName.mainNavigationPage);
          }
        }

        if (state is SplashUnauthenticated) {
          context.go(RoutesName.login);
        }
      },
      child: Scaffold(
        backgroundColor: _SplashPalette.teal,
        body: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state is SplashLoading) {
              return const _SplashLoadingView();
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SplashLoadingView extends StatelessWidget {
  const _SplashLoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_SplashPalette.teal, _SplashPalette.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -58, left: -44, child: _SplashRing(size: 170)),
          Positioned(top: 92, right: -56, child: _SplashRing(size: 150)),
          Positioned(bottom: 120, left: -42, child: _SplashRing(size: 130)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Expense Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your money, in perspective.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashRing extends StatelessWidget {
  final double size;

  const _SplashRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
    );
  }
}
