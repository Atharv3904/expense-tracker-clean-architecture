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

class _ProfilePalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const softMint = Color(0xFFEAF8F5);
  static const danger = Color(0xFFE8524A);
}

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

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 650.0
        : 700.0;

    return Scaffold(
      backgroundColor: _ProfilePalette.bg,
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
            return const _ProfileSkeleton();
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  const _ProfileTopBackground(),
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
                            children: [
                              _ProfileHeader(isMobile: isMobile),
                              SizedBox(height: isMobile ? 24 : 30),
                              _ProfileCard(
                                name: profile.name ?? 'User',
                                email: profile.email ?? 'abc123@gmail.com',
                                isMobile: isMobile,
                              ),
                              const SizedBox(height: 24),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Account Settings',
                                  style: TextStyle(
                                    color: _ProfilePalette.ink,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ProfileOption(
                                icon: Icons.edit_outlined,
                                title: 'Edit Profile',
                                subtitle: 'Update your personal information',
                                onTap: () async {
                                  final profileBloc = context
                                      .read<ProfileBloc>();

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
                                icon: Icons.remember_me_rounded,
                                title: 'Reminder',
                                subtitle:
                                    'Create your reminder for daily expenses',
                                onTap: () async {
                                  await context.push(RoutesName.reminderPage);
                                },
                              ),
                              const SizedBox(height: 12),
                              ProfileOption(
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                subtitle: 'Sign out from your account',
                                iconColor: _ProfilePalette.danger,
                                titleColor: _ProfilePalette.danger,
                                onTap: () {
                                  context.push(RoutesName.logout);
                                },
                              ),
                              const SizedBox(height: 28),
                              _VersionTile(appVersion: appVersion),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _ProfileTopBackground extends StatelessWidget {
  const _ProfileTopBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_ProfilePalette.teal, _ProfilePalette.tealDark],
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
          Positioned(top: 42, right: -38, child: _HeaderRing(size: 126)),
          Positioned(top: 86, left: 90, child: _HeaderRing(size: 64)),
        ],
      ),
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

class _ProfileHeader extends StatelessWidget {
  final bool isMobile;

  const _ProfileHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: const SizedBox(
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final bool isMobile;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 30,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: _ProfilePalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _ProfilePalette.softMint,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: CircleAvatar(
              radius: isMobile ? 48 : 55,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_rounded,
                size: isMobile ? 48 : 55,
                color: _ProfilePalette.teal,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ProfilePalette.ink,
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ProfilePalette.muted,
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  final String appVersion;

  const _VersionTile({required this.appVersion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ProfilePalette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _ProfilePalette.softMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: _ProfilePalette.teal,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'App Version',
              style: TextStyle(
                color: _ProfilePalette.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            appVersion.isEmpty ? 'Loading...' : appVersion,
            style: const TextStyle(
              color: _ProfilePalette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _ProfileTopBackground(),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: const [
              _SkeletonBlock(height: 42, radius: 22),
              SizedBox(height: 24),
              _SkeletonBlock(height: 220, radius: 30),
              SizedBox(height: 24),
              _SkeletonBlock(height: 72, radius: 24),
              SizedBox(height: 12),
              _SkeletonBlock(height: 72, radius: 24),
              SizedBox(height: 12),
              _SkeletonBlock(height: 72, radius: 24),
              SizedBox(height: 12),
              _SkeletonBlock(height: 72, radius: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double height;
  final double radius;

  const _SkeletonBlock({required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _ProfilePalette.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
