import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/auth_background.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/field_icon.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/login_bottom_links.dart';
import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/login_header.dart';
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
        color: const Color(0xFFF3F6F4),
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
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF07091D,
                          ).withValues(alpha: 0.08),
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
                          LoginHeader(isMobile: isMobile),

                          SizedBox(height: isMobile ? 28 : 36),

                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) {
                              _updateButtonVisibility();
                            },
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
                            onChanged: (_) {
                              _updateButtonVisibility();
                            },
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
                                      color: Color(0xFF2B8F84),
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
                                    backgroundColor: Colors.teal,
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

                          const LoginBottomLinks(),
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
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 10),
        child: FieldIcon(icon: icon),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE8EEEB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE8EEEB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF2B8F84), width: 1.4),
      ),
    );
  }
}
