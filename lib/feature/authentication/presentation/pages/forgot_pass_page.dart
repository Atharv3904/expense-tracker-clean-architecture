import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';
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

  @override
  void dispose() {
    emailController.dispose();
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
        appBar: AppBar(title: const Text('Forgot Password')),

        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
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

                    child: BlocBuilder<ForgotPassCubit, ForgotPassState>(
                      builder: (context, state) {
                        final isLoading = state is ForgotPassLoading;

                        return Column(
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
                                Icons.lock_reset,
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
                              'Reset your password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 19 : 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Enter your email and we will send you '
                              'a password reset link.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),

                            SizedBox(height: isMobile ? 24 : 30),

                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,

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
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              height: 52,

                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final email = emailController.text
                                            .trim();

                                        if (email.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Enter your email'),
                                            ),
                                          );
                                          return;
                                        }

                                        final emailpass = ForgotPasswordParams(
                                          email: email,
                                        );

                                        context
                                            .read<ForgotPassCubit>()
                                            .forgotPassword(emailpass);
                                      },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            TextButton(
                              onPressed: () {
                                context.go(RoutesName.login);
                              },

                              child: const Text(
                                'Back to Login',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
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
          ),
        ),
      ),
    );
  }
}
