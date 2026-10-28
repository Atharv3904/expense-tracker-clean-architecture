import 'package:expense_tracker/core/notification/device_token_service.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _LoginPagePalette {
  static const bg = Color(0xFFF3F6F4);
}

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
      final alreadyEnabled = await cubit.isBiometricEnabled(state.userId!);

      if (!context.mounted) return;

      if (alreadyEnabled) {
        cubit.clearPendingBiometricOptIn();
        return;
      }

      final biometricAvailable = await cubit.isBiometricAvailable();

      if (!context.mounted) return;

      if (!biometricAvailable) {
        cubit.clearPendingBiometricOptIn();
        return;
      }

      final enable = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Enable fingerprint login?'),
            content: const Text(
              'Would you like to use your device biometrics '
              'to log in to Spendly next time? Your login '
              'credentials will be stored securely on this device '
              'only if you choose Enable.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Enable'),
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
        backgroundColor: _LoginPagePalette.bg,
        body: SafeArea(child: LoginForm()),
      ),
    );
  }
}
