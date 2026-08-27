import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/params/register_params.dart';
import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final params = RegisterParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
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

    // Responsive horizontal padding
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    // Maximum form width
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
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 20 : 40,
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),

            child: Card(
              elevation: isMobile ? 8 : 14,

              shadowColor: Colors.black26,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              ),

              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 32),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        width: isMobile ? 58 : 70,
                        height: isMobile ? 58 : 70,

                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.10),

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                          size: isMobile ? 34 : 42,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Expense Tracker',

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: isMobile ? 25 : 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Create your account',

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: isMobile ? 26 : 34),

                      TextFormField(
                        controller: emailController,

                        keyboardType: TextInputType.emailAddress,

                        textInputAction: TextInputAction.next,

                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',

                          prefixIcon: const Icon(Icons.email_outlined),

                          filled: true,
                          fillColor: Colors.grey[50],

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
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

                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',

                          prefixIcon: const Icon(Icons.lock_outline),

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

                          filled: true,
                          fillColor: Colors.grey[50],

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 1.5,
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

                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          if (state is RegisterLoading) {
                            return const SizedBox(
                              height: 52,

                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            height: 52,

                            child: ElevatedButton(
                              onPressed: _register,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,

                                foregroundColor: Colors.white,

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              child: const Text(
                                'Register',

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 22),

                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          children: [
                            WidgetSpan(
                              child: TextButton(
                                onPressed: () {
                                  context.go(RoutesName.login);
                                },

                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
