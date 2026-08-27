import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/profile_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(const LoadProfile());
    loadAppVersion();
  }

  Future<void> loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 16.0 : 24.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 650.0
        : 700.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7F7FA),
        elevation: 0,
      ),

      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),

                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,

                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 30,
                          vertical: 28,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              padding: const EdgeInsets.all(4),

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),

                                  width: 3,
                                ),
                              ),

                              child: CircleAvatar(
                                radius: isMobile ? 48 : 55,

                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,

                                child: Icon(
                                  Icons.person,
                                  size: isMobile ? 48 : 55,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Name
                            Text(
                              profile.name ?? 'User',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: isMobile ? 23 : 26,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Email
                            Text(
                              profile.email ?? 'abc123@gmail.com',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isMobile ? 14 : 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,

                        child: const Text(
                          'Account Settings',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ProfileOption(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',

                        onTap: () async {
                          final profileBloc = context.read<ProfileBloc>();

                          final result = await context.push(
                            RoutesName.editProfile,
                            extra: profile.name ?? '',
                          );

                          if (result == true && context.mounted) {
                            profileBloc.add(const LoadProfile());
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      ProfileOption(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        subtitle: 'Update your account password',

                        onTap: () async {
                          await context.push(RoutesName.changePassword);
                        },
                      ),

                      const SizedBox(height: 12),

                      ProfileOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Sign out from your account',

                        iconColor: Colors.red,
                        titleColor: Colors.red,

                        onTap: () {
                          context.push(RoutesName.logout);
                        },
                      ),
                      SizedBox(height: 50),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('App Version'),
                          trailing: Text(
                            appVersion.isEmpty ? 'Loading...' : appVersion,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
