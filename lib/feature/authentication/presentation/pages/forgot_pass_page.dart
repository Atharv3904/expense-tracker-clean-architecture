import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
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
  static const softMint = Color(0xFFEAF8F5);
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

    final emailpass = ForgotPasswordParams(email: email);

    context.read<ForgotPassCubit>().forgotPassword(emailpass);
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
      listener: (context, state) {
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
      },
      child: Scaffold(
        backgroundColor: _ForgotPalette.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            color: _ForgotPalette.bg,
            child: Stack(
              children: [
                const _AuthBackground(),
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
                                Container(
                                  width: isMobile ? 68 : 78,
                                  height: isMobile ? 68 : 78,
                                  decoration: const BoxDecoration(
                                    color: _ForgotPalette.softMint,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.lock_reset_rounded,
                                    color: _ForgotPalette.teal,
                                    size: isMobile ? 35 : 42,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Expense Tracker',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _ForgotPalette.ink,
                                    fontSize: isMobile ? 28 : 34,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Reset your password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _ForgotPalette.ink,
                                    fontSize: isMobile ? 19 : 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Enter your email and we will send you a password reset link.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _ForgotPalette.muted,
                                    fontSize: isMobile ? 13 : 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: isMobile ? 24 : 30),
                                TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: _ForgotPalette.ink,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: _inputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    icon: Icons.email_outlined,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : _sendResetLink,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _ForgotPalette.teal,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: _ForgotPalette
                                          .teal
                                          .withValues(alpha: 0.52),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Send Reset Link',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(
        color: _ForgotPalette.muted,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(
        color: _ForgotPalette.muted.withValues(alpha: 0.75),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 10),
        child: _FieldIcon(icon: icon),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _ForgotPalette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _ForgotPalette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _ForgotPalette.teal, width: 1.4),
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 260,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_ForgotPalette.teal, _ForgotPalette.tealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(38),
              bottomRight: Radius.circular(38),
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -42, left: -34, child: _HeaderRing(size: 132)),
              Positioned(top: 44, right: -40, child: _HeaderRing(size: 128)),
              Positioned(top: 92, left: 96, child: _HeaderRing(size: 64)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;

  const _HeaderRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}

class _FieldIcon extends StatelessWidget {
  final IconData icon;

  const _FieldIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _ForgotPalette.teal.withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: _ForgotPalette.teal, size: 18),
    );
  }
}
