import 'dart:ui';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/auth_background.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/params/register_params.dart';
import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_state.dart';

class _RegisterPalette {
  static const teal = Color(0xFF1B7A70);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const softMint = Color(0xFFE6F7F5);
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String selectedRole = 'user';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final params = RegisterParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole, // Set the role to 'user' for registration
    );

    context.read<RegisterCubit>().register(params);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = isMobile ? 18.0 : 28.0;

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
      child: LiquidGlassBackground(
        child: Stack(
            children: [
              const AuthBackground(),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
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
                                    : _RegisterPalette.teal.withValues(alpha: 0.12),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : _RegisterPalette.ink.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
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
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF134E4A)
                                  : _RegisterPalette.softMint,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: isDark
                                  ? const Color(0xFF2DD4BF)
                                  : _RegisterPalette.teal,
                              size: isMobile ? 34 : 40,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Spendly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : _RegisterPalette.ink,
                              fontSize: isMobile ? 28 : 34,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : _RegisterPalette.muted,
                              fontSize: isMobile ? 14 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: isMobile ? 28 : 36),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: isDark ? Colors.white : _RegisterPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: inputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: Icons.email_outlined,
                              isDark: isDark,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                              color: isDark ? Colors.white : _RegisterPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: inputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                              isDark: isDark,
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
                                  color: isDark ? Colors.white70 : _RegisterPalette.muted,
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

                          const SizedBox(height: 18),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !isConfirmPasswordVisible,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                              color: isDark ? Colors.white : _RegisterPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: inputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                              isDark: isDark,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: isDark ? Colors.white70 : _RegisterPalette.muted,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password is Required';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          DropdownButtonFormField<String>(
                            initialValue: selectedRole,
                            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            style: TextStyle(
                              color: isDark ? Colors.white : _RegisterPalette.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            decoration: inputDecoration(
                              labelText: 'Select Role',
                              hintText: 'Choose your role',
                              icon: Icons.manage_accounts_outlined,
                              isDark: isDark,
                            ),
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'user',
                                child: Text('User'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'admin',
                                child: Text('Admin'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedRole = value;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 24),
                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              if (state is RegisterLoading) {
                                return const SizedBox(
                                  height: 54,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: _RegisterPalette.teal,
                                    ),
                                  ),
                                );
                              }

                               return LiquidGlassButton(
                                 onPressed: _register,
                                 label: 'Register',
                               );
                            },
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF94A3B8) : _RegisterPalette.muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(RoutesName.login);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: isDark ? const Color(0xFF2DD4BF) : _RegisterPalette.teal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Login',
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
          ),
        ),
      ],
    ),
  ),
);
  }
}
