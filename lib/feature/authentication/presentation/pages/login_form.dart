// ignore_for_file: use_key_in_widget_constructors

import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _LoginPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const softMint = Color(0xFFEAF8F5);
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isButtonVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final params = LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    context.read<LoginCubit>().login(params);
  }

  void _updateButtonVisibility() {
    setState(() {
      isButtonVisible =
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: _LoginPalette.bg,
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
                          color: _LoginPalette.ink.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: isMobile ? 68 : 78,
                            height: isMobile ? 68 : 78,
                            decoration: const BoxDecoration(
                              color: _LoginPalette.softMint,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: _LoginPalette.teal,
                              size: isMobile ? 34 : 40,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Expense Tracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _LoginPalette.ink,
                              fontSize: isMobile ? 28 : 34,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back, login to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _LoginPalette.muted,
                              fontSize: isMobile ? 14 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: isMobile ? 28 : 36),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => _updateButtonVisibility(),
                            style: const TextStyle(
                              color: _LoginPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _inputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => _updateButtonVisibility(),
                            style: const TextStyle(
                              color: _LoginPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _inputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: _LoginPalette.muted,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }

                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return const SizedBox(
                                  height: 54,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: _LoginPalette.teal,
                                    ),
                                  ),
                                );
                              }

                              if (!isButtonVisible) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _LoginPalette.teal,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              const Text(
                                'New here?',
                                style: TextStyle(
                                  color: _LoginPalette.muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(RoutesName.register);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _LoginPalette.teal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Create account',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(RoutesName.forgotPage);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _LoginPalette.teal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(
        color: _LoginPalette.muted,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(
        color: _LoginPalette.muted.withValues(alpha: 0.75),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 10),
        child: _FieldIcon(icon: icon),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _LoginPalette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _LoginPalette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _LoginPalette.teal, width: 1.4),
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
              colors: [_LoginPalette.teal, _LoginPalette.tealDark],
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
        color: _LoginPalette.teal.withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: _LoginPalette.teal, size: 18),
    );
  }
}
