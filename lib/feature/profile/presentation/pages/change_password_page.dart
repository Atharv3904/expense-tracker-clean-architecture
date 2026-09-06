import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_auth_background.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_card.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_colors.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_header.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_intro_tile.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_section_label.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void changePassword() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter password')));

      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );

      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));

      return;
    }

    context.read<ProfileBloc>().add(ChangePassword(password));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 600.0
        : 650.0;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          context.pop();
        }

        if (state is ProfileFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                const AppAuthBackground(height: 245),

                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          isMobile ? 16 : 24,
                          horizontalPadding,
                          28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppHeader(
                              title: 'Change Password',
                              isMobile: isMobile,
                            ),

                            SizedBox(height: isMobile ? 28 : 34),

                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppIntroTile(
                                    icon: Icons.lock_outline_rounded,
                                    title: 'Security',
                                    subtitle:
                                        'Create a new secure password for your account',
                                  ),

                                  const SizedBox(height: 26),

                                  const AppSectionLabel('New Password'),

                                  const SizedBox(height: 10),

                                  AppTextField(
                                    controller: passwordController,
                                    hintText: 'Enter your new password',
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: !isPasswordVisible,
                                    textInputAction: TextInputAction.next,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  const AppSectionLabel('Confirm Password'),

                                  const SizedBox(height: 10),

                                  AppTextField(
                                    controller: confirmPasswordController,
                                    hintText: 'Confirm your new password',
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: !isConfirmPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isConfirmPasswordVisible =
                                              !isConfirmPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isConfirmPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  const _PasswordHint(),

                                  const SizedBox(height: 28),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: changePassword,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.teal,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock_reset_rounded),
                                          SizedBox(width: 8),
                                          Text(
                                            'Change Password',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordHint extends StatelessWidget {
  const _PasswordHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: AppColors.teal),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Password must contain at least 6 characters / numbers.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
