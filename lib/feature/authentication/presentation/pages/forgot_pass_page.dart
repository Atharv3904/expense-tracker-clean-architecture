import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_widgets.dart/forgot_password_background.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_widgets.dart/forgot_password_button.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_widgets.dart/forgot_password_header.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/forgot_password_widgets.dart/forgot_password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _ForgotPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
}

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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter your email')));
      return;
    }

    final emailPass = ForgotPasswordParams(email: email);

    context.read<ForgotPassCubit>().forgotPassword(emailPass);
  }

  void _handleState(BuildContext context, ForgotPassState state) {
    if (state is ForgotPassSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent successfully.'),
        ),
      );

      context.go(RoutesName.login);
    }

    if (state is ForgotPassFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
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
        backgroundColor: _ForgotPalette.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Stack(
            children: [
              const ForgotPasswordBackground(
                teal: _ForgotPalette.teal,
                tealDark: _ForgotPalette.tealDark,
              ),

              Center(
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
                            color: _ForgotPalette.ink.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: BlocBuilder<ForgotPassCubit, ForgotPassState>(
                        builder: (context, state) {
                          final isLoading = state is ForgotPassLoading;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ForgotPasswordHeader(
                                isMobile: isMobile,
                                teal: _ForgotPalette.teal,
                                ink: _ForgotPalette.ink,
                                muted: _ForgotPalette.muted,
                              ),

                              SizedBox(height: isMobile ? 24 : 30),

                              ForgotPasswordInput(
                                controller: emailController,
                                ink: _ForgotPalette.ink,
                                muted: _ForgotPalette.muted,
                                border: _ForgotPalette.border,
                                teal: _ForgotPalette.teal,
                              ),

                              const SizedBox(height: 22),

                              ForgotPasswordButton(
                                isLoading: isLoading,
                                onPressed: _sendResetLink,
                                teal: _ForgotPalette.teal,
                              ),

                              const SizedBox(height: 18),

                              TextButton(
                                onPressed: () {
                                  context.go(RoutesName.login);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _ForgotPalette.teal,
                                ),
                                child: const Text(
                                  'Back to Login',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
