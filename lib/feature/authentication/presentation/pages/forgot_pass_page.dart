import 'dart:ui';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/color_pallete.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_background.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_button.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_header.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordView();
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = emailController.text.trim();

    final emailPass = ForgotPasswordParams(email: email);

    context.read<ForgotPassCubit>().forgotPassword(emailPass);
  }

  void _handleState(BuildContext context, ForgotPassState state) {
    if (state is ForgotPassSuccess) {
      AppSnackbar.show(
        context,
        message: "Password reset email sent successfully",
      );

      context.go(RoutesName.login);
    }

    if (state is ForgotPassFailure) {
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
                          final isLoading = state is ForgotPassLoading;

                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ForgotPasswordHeader(
                                  isMobile: isMobile,
                                  teal: effectiveTeal,
                                  ink: effectiveInk,
                                  muted: effectiveMuted,
                                ),

                                SizedBox(height: isMobile ? 24 : 30),

                                ForgotPasswordInput(
                                  controller: emailController,
                                  ink: effectiveInk,
                                  muted: effectiveMuted,
                                  border: isDark ? Colors.white.withValues(alpha: 0.12) : ColorPallete.border,
                                  teal: effectiveTeal,
                                ),

                                const SizedBox(height: 22),

                                ForgotPasswordButton(
                                  isLoading: isLoading,
                                  onPressed: _sendResetLink,
                                  teal: effectiveTeal,
                                ),

                                const SizedBox(height: 18),

                                TextButton(
                                  onPressed: () {
                                    context.go(RoutesName.login);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: effectiveTeal,
                                  ),
                                  child: const Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
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
