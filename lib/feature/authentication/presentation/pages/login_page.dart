import 'package:expense_tracker/core/notification/device_token_service.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleBiometricOptIn(
    BuildContext context,
    LoginSuccess state,
  ) async {
    final cubit = context.read<LoginCubit>();

    // Biometric login should only be offered after normal login.
    if (state.isBiometricLogin || state.userId == null || state.email == null) {
      cubit.clearPendingBiometricOptIn();
      return;
    }

    try {
      final biometricAvailable = await cubit.isBiometricAvailable();

      if (!context.mounted) return;

      if (!biometricAvailable) {
        cubit.clearPendingBiometricOptIn();
        return;
      }

      final isDark = Theme.of(context).brightness == Brightness.dark;
      final enable = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.9),
                width: 1.2,
              ),
            ),
            title: Text(
              'Enable fingerprint login?',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              'Would you like to use fingerprint login for ${state.email} next time? '
              'Your login credentials will be stored securely on this device.',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: Text(
                  'Not now',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7A70),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text(
                  'Enable',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          );
        },
      );

      if (!context.mounted) {
        cubit.clearPendingBiometricOptIn();
        return;
      }

      if (enable == true) {
        try {
          await cubit.enableBiometricLoginForPendingUser(
            userId: state.userId!,
            email: state.email!,
          );

          if (context.mounted) {
            AppSnackbar.show(context, message: 'Fingerprint login enabled');
          }
        } catch (_) {
          if (context.mounted) {
            AppSnackbar.show(
              context,
              message:
                  'Could not enable fingerprint login. '
                  'You can continue using your password.',
            );
          }
        }
      } else {
        await cubit.disableBiometricForUser(state.userId!);
        cubit.clearPendingBiometricOptIn();
      }
    } catch (_) {
      cubit.clearPendingBiometricOptIn();
      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: 'Could not check biometric availability.',
        );
      }
    }
  }

  Future<void> _navigateAfterLogin(
    BuildContext context,
    LoginSuccess state,
  ) async {
    if (state.role != 'admin' && state.role != 'user') {
      AppSnackbar.show(context, message: 'Invalid or missing user role.');
      return;
    }

    final deviceTokenService = DeviceTokenService();

    try {
      await deviceTokenService.saveToken();
      deviceTokenService.listenForTokenRefresh();
    } catch (_) {
      // A notification-token issue should not block login.
    }

    if (!context.mounted) return;

    if (state.role == 'admin') {
      context.pushReplacement(RoutesName.adminDashboard);
    } else {
      context.pushReplacement(RoutesName.mainNavigationPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          await _handleBiometricOptIn(context, state);

          if (!context.mounted) return;

          AppSnackbar.show(context, message: 'Login Successful');

          await _navigateAfterLogin(context, state);
        }

        if (state is LoginFailure) {
          if (!context.mounted) return;

          context.read<LoginCubit>().clearPendingBiometricOptIn();

          AppSnackbar.show(context, message: state.message);
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: LoginForm()),
      ),
    );
  }
}
