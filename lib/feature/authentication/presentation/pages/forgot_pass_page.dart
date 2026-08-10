import 'package:expense_tracker/core/di/injection_container.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPassCubit>(),
      child: const ForgotPasswordView(),
    );
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
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 20,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: BlocBuilder<ForgotPassCubit, ForgotPassState>(
                  builder: (context, state) {
                    final isLoading = state is ForgotPassLoading;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                          size: 70,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Expense Tracker",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          'Reset your password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Enter your email and we will send you a password reset link.',
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final email = emailController.text.trim();

                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Enter your email'),
                                      ),
                                    );
                                    return;
                                  }
                                  final ForgotPasswordParams emailpass =
                                      ForgotPasswordParams(email: email);
                                  context
                                      .read<ForgotPassCubit>()
                                      .forgotPassword(emailpass);
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Send Reset Link'),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            context.go(RoutesName.login);
                          },
                          child: const Text('Back to Login'),
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
    );
  }
}
