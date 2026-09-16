import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _UpdatePasswordPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UpdatePasswordView();
  }
}

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final params = UpdatePasswordParams(
      password: passwordController.text.trim(),
    );

    context.read<ForgotPassCubit>().updatePassword(params);
  }

  void _handleState(BuildContext context, ForgotPassState state) {
    if (state is UpdatePasswordSuccess) {
      AppSnackbar.show(context, message: 'Password updated successfully');

      context.go(RoutesName.login);
    }

    if (state is UpdatePasswordFailure) {
      AppSnackbar.show(context, message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 600.0
        : 700.0;

    return BlocListener<ForgotPassCubit, ForgotPassState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: _UpdatePasswordPalette.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 28,
                vertical: isMobile ? 22 : 42,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 20 : 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _UpdatePasswordPalette.ink.withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: BlocBuilder<ForgotPassCubit, ForgotPassState>(
                    builder: (context, state) {
                      final isLoading = state is UpdatePasswordLoading;

                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_reset_rounded,
                              size: isMobile ? 55 : 65,
                              color: _UpdatePasswordPalette.teal,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Create New Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 25 : 30,
                                fontWeight: FontWeight.w900,
                                color: _UpdatePasswordPalette.ink,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Enter your new password below.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: _UpdatePasswordPalette.muted,
                              ),
                            ),

                            const SizedBox(height: 30),

                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                hintText: 'Enter new password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: _UpdatePasswordPalette.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: _UpdatePasswordPalette.teal,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your new password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!isLoading) {
                                  _updatePassword();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Enter password again',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: _UpdatePasswordPalette.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: _UpdatePasswordPalette.teal,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Confirm your password';
                                }

                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _updatePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _UpdatePasswordPalette.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Update Password',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.go(RoutesName.login);
                                    },
                              child: const Text(
                                'Back to Login',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
