import 'dart:ui';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/auth_background.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/input_decoration.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_bottom_links.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isButtonVisible = false;
  bool isBiometricAvailable = false;
  bool isCheckingBiometrics = true;
  String? biometricUserId;
  String? biometricEmail;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadBiometricOption();
    });
  }

  Future<void> _loadBiometricOption() async {
    final cubit = context.read<LoginCubit>();

    final available = await cubit.isBiometricAvailable();
    final userId = available ? await cubit.getBiometricUserId() : null;
    final email = userId != null ? await cubit.getBiometricEmail(userId) : null;

    if (!mounted) return;

    setState(() {
      isBiometricAvailable = available;
      biometricUserId = userId;
      biometricEmail = email;
      isCheckingBiometrics = false;
    });
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final password = passwordController.text;

    context.read<LoginCubit>().login(
      LoginParams(email: emailController.text.trim(), password: password),
    );
  }

  void _updateButtonVisibility() {
    setState(() {
      isButtonVisible =
          emailController.text.trim().isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  Future<void> _loginWithBiometrics() async {
    final userId = biometricUserId;
    if (userId == null) return;

    await context.read<LoginCubit>().loginWithBiometrics(userId);
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

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 600.0
        : 700.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LiquidGlassBackground(
        child: Stack(
          children: [
            const AuthBackground(),
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
                                  : const Color(0xFF1B7A70).withValues(alpha: 0.12),
                              blurRadius: 32,
                              offset: const Offset(0, 16),
                            ),
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
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
                              LoginHeader(isMobile: isMobile),
                              SizedBox(height: isMobile ? 28 : 36),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                onChanged: (_) => _updateButtonVisibility(),
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

                                  if (!emailRegex.hasMatch(value.trim())) {
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
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                onChanged: (_) => _updateButtonVisibility(),
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
                                      color: isDark ? Colors.white70 : null,
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
                                  final isLoading = state is LoginLoading;

                                  return Column(
                                    children: [
                                      if (isLoading)
                                        const SizedBox(
                                          height: 54,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF1B7A70),
                                            ),
                                          ),
                                        )
                                      else if (isButtonVisible)
                                        LiquidGlassButton(
                                          onPressed: _login,
                                          label: 'Login',
                                        ),
                                      if (!isLoading &&
                                          !isCheckingBiometrics &&
                                          isBiometricAvailable &&
                                          biometricUserId != null) ...[
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: OutlinedButton.icon(
                                            onPressed: _loginWithBiometrics,
                                            icon: const Icon(Icons.fingerprint),
                                            label: Text(
                                              biometricEmail != null &&
                                                      biometricEmail!.isNotEmpty
                                                  ? 'Login as $biometricEmail'
                                                  : 'Login with fingerprint',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(0xFF1B7A70),
                                              side: BorderSide(
                                                color: const Color(0xFF1B7A70).withValues(alpha: 0.35),
                                                width: 1.4,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              const LoginBottomLinks(),
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
