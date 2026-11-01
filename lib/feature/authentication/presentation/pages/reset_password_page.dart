import 'dart:ui';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/color_pallete.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveInk = isDark ? Colors.white : ColorPallete.ink;
    final effectiveMuted = isDark ? const Color(0xFF94A3B8) : ColorPallete.muted;
    final effectiveTeal = isDark ? const Color(0xFF2DD4BF) : ColorPallete.teal;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 600.0
        : 700.0;

    return BlocListener<ForgotPassCubit, ForgotPassState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LiquidGlassBackground(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Stack(
              children: [
                const ForgotPasswordBackground(
                  teal: ColorPallete.teal,
                  tealDark: ColorPallete.tealDark,
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 18 : 28,
                      vertical: isMobile ? 22 : 42,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 22 : 32),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B).withValues(alpha: 0.72)
                                  : Colors.white.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.14)
                                    : Colors.white.withValues(alpha: 0.95),
                                width: 1.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : ColorPallete.teal.withValues(alpha: 0.12),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.2)
                                      : ColorPallete.ink.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
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
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [
                                          const Color(0xFF134E4A),
                                          const Color(0xFF0F766E),
                                        ]
                                      : [
                                          ColorPallete.teal.withValues(alpha: 0.15),
                                          ColorPallete.tealLight.withValues(alpha: 0.08),
                                        ],
                                ),
                                border: Border.all(
                                  color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_reset_rounded,
                                size: isMobile ? 48 : 56,
                                color: effectiveTeal,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Create New Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 25 : 30,
                                fontWeight: FontWeight.w900,
                                color: effectiveInk,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Enter your new password below.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: effectiveMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 28),

                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                color: effectiveInk,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(color: effectiveMuted, fontWeight: FontWeight.w600),
                                hintText: 'Enter new password',
                                hintStyle: TextStyle(
                                  color: effectiveMuted.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: effectiveTeal,
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
                                    color: effectiveMuted,
                                  ),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF1E293B).withValues(alpha: 0.65)
                                    : Colors.white.withValues(alpha: 0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.white.withValues(alpha: 0.12) : ColorPallete.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: effectiveTeal,
                                    width: 1.8,
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
                              style: TextStyle(
                                color: effectiveInk,
                                fontWeight: FontWeight.w700,
                              ),
                              onFieldSubmitted: (_) {
                                if (!isLoading) {
                                  _updatePassword();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(color: effectiveMuted, fontWeight: FontWeight.w600),
                                hintText: 'Enter password again',
                                hintStyle: TextStyle(
                                  color: effectiveMuted.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: effectiveTeal,
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
                                    color: effectiveMuted,
                                  ),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF1E293B).withValues(alpha: 0.65)
                                    : Colors.white.withValues(alpha: 0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.white.withValues(alpha: 0.12) : ColorPallete.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: effectiveTeal,
                                    width: 1.8,
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

                            const SizedBox(height: 26),

                            LiquidGlassButton(
                              onPressed: isLoading ? null : _updatePassword,
                              height: 52,
                              width: double.infinity,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0F766E),
                                  Color(0xFF0D9488),
                                ],
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
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Update Password',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            ),

                            const SizedBox(height: 18),

                            TextButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.go(RoutesName.login);
                                    },
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 16,
                                color: ColorPallete.teal,
                              ),
                              label: const Text(
                                'Back to Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: ColorPallete.teal,
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
