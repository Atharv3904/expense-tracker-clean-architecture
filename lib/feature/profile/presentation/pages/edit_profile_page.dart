import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_auth_background.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_card.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_colors.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_header.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_intro_tile.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;

  const EditProfilePage({super.key, required this.currentName});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void updateProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();

    context.read<ProfileBloc>().add(UpdateProfile(name));
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

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              context.pop(true);
            }

            if (state is ProfileFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppHeader(
                                title: 'Edit Profile',
                                isMobile: isMobile,
                                onBack: () {
                                  context.pop();
                                },
                              ),

                              SizedBox(height: isMobile ? 28 : 34),

                              AppCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppIntroTile(
                                      icon: Icons.person_outline_rounded,
                                      title: 'Personal Information',
                                      subtitle:
                                          'Update your name and profile information',
                                    ),

                                    const SizedBox(height: 26),

                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        color: AppColors.ink,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    AppTextField(
                                      controller: nameController,
                                      hintText: 'Enter your name',
                                      icon: Icons.person_outline_rounded,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Please enter your name';
                                        }

                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 28),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: updateProfile,
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
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Save Changes',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
