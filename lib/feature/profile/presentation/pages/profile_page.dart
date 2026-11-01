import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/services/biometric_service.dart';
import 'package:expense_tracker/core/theme/cubit/theme_cubit.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/biometric_credential_local_datasource_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';

import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';

import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/app_auth_background.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/app_colors.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/app_header.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/profile_card.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/profile_option.dart';

import 'package:expense_tracker/feature/profile/presentation/widget/version_tile.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onBack;

  const ProfilePage({super.key, required this.onBack});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String appVersion = '';
  String? avatarUrl;
  bool _isBiometricSupported = false;
  bool _isBiometricEnabled = false;
  final _biometricService = sl<BiometricService>();
  final _biometricStorage = sl<BiometricCredentialLocalDatasourceService>();

  @override
  void initState() {
    super.initState();

    loadAppVersion();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final available = await _biometricService.isBiometricAvailable();
    final user = Supabase.instance.client.auth.currentUser;
    final enabled =
        user != null && await _biometricStorage.isEnabled(user.id);

    if (!mounted) return;

    setState(() {
      _isBiometricSupported = available;
      _isBiometricEnabled = enabled;
    });
  }

  Future<String?> _showPasswordPromptDialog({
    required String title,
    required String subtitle,
    required String confirmButtonLabel,
    required String email,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        bool obscure = true;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.16)
                      : Colors.white.withValues(alpha: 0.9),
                  width: 1.2,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF64748B),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF0F172A).withValues(alpha: 0.7)
                          : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.14)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.14)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF1B7A70),
                          width: 1.8,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                        onPressed: () {
                          setDialogState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, null),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, passwordController.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7A70),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    confirmButtonLabel,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleBiometric(bool enable, String email) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    if (!_isBiometricSupported) {
      AppSnackbar.show(
        context,
        message: 'Fingerprint is not available or enrolled on this device.',
      );
      if (!mounted) return;
      setState(() => _isBiometricEnabled = false);
      return;
    }

    if (!enable) {
      // 1. Biometric authentication required to disable
      final authResult = await _biometricService.authenticateWithResult(
        localizedReason: 'Scan fingerprint to disable biometric login',
      );

      if (authResult == BiometricAuthResult.success) {
        await _biometricStorage.setEnabled(user.id, false);
        if (!mounted) return;
        setState(() => _isBiometricEnabled = false);
        AppSnackbar.show(context, message: 'Fingerprint login disabled');
        return;
      }

      if (authResult == BiometricAuthResult.cancelled) {
        if (!mounted) return;
        setState(() => _isBiometricEnabled = true);
        return;
      }

      // If biometric failed, offer password fallback to disable
      final enteredPassword = await _showPasswordPromptDialog(
        title: 'Disable Fingerprint Login',
        subtitle:
            'Fingerprint scan failed. Enter your account password to confirm disabling fingerprint login.',
        confirmButtonLabel: 'Verify & Disable',
        email: user.email ?? email,
      );

      if (enteredPassword == null || enteredPassword.isEmpty) {
        if (!mounted) return;
        setState(() => _isBiometricEnabled = true);
        return;
      }

      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: user.email ?? email,
          password: enteredPassword,
        );

        await _biometricStorage.setEnabled(user.id, false);
        if (!mounted) return;
        setState(() => _isBiometricEnabled = false);
        AppSnackbar.show(context, message: 'Fingerprint login disabled');
      } catch (_) {
        if (!mounted) return;
        setState(() => _isBiometricEnabled = true);
        AppSnackbar.show(
          context,
          message: 'Incorrect password. Fingerprint login remains enabled.',
        );
      }
      return;
    }

    // ENABLE FLOW
    final hasSavedCredentials =
        await _biometricStorage.hasSavedCredentials(user.id);

    if (hasSavedCredentials) {
      // Use biometric directly!
      final authResult = await _biometricService.authenticateWithResult(
        localizedReason: 'Scan fingerprint to enable biometric login',
      );

      if (authResult == BiometricAuthResult.success) {
        await _biometricStorage.setEnabled(user.id, true);
        if (!mounted) return;
        setState(() => _isBiometricEnabled = true);
        AppSnackbar.show(
          context,
          message: 'Fingerprint login enabled successfully',
        );
        return;
      }

      if (authResult == BiometricAuthResult.cancelled) {
        if (!mounted) return;
        setState(() => _isBiometricEnabled = false);
        return;
      }

      // Biometric scan failed, allow password fallback below
    }

    // If no credentials saved yet or biometric failed, prompt for password
    final enteredPassword = await _showPasswordPromptDialog(
      title: 'Enable Fingerprint Login',
      subtitle:
          'Enter your account password to enable fingerprint login on this device.',
      confirmButtonLabel: 'Verify & Enable',
      email: user.email ?? email,
    );

    if (enteredPassword == null || enteredPassword.isEmpty) {
      if (!mounted) return;
      setState(() => _isBiometricEnabled = false);
      return;
    }

    try {
      // 1. Verify password with Supabase
      await Supabase.instance.client.auth.signInWithPassword(
        email: user.email ?? email,
        password: enteredPassword,
      );

      // 2. Verify fingerprint scan directly
      final authResult = await _biometricService.authenticateWithResult(
        localizedReason: 'Scan fingerprint to enable biometric login',
      );

      if (authResult != BiometricAuthResult.success) {
        if (mounted) {
          setState(() => _isBiometricEnabled = false);
          AppSnackbar.show(
            context,
            message: 'Fingerprint verification was cancelled or failed.',
          );
        }
        return;
      }

      // 3. Save credentials and enable
      await _biometricStorage.enable(
        userId: user.id,
        email: user.email ?? email,
        password: enteredPassword,
      );

      if (!mounted) return;
      setState(() => _isBiometricEnabled = true);
      AppSnackbar.show(
        context,
        message: 'Fingerprint login enabled successfully',
      );
    } catch (_) {
      if (mounted) {
        setState(() => _isBiometricEnabled = false);
        AppSnackbar.show(
          context,
          message:
              'Incorrect password or authentication failed. Please try again.',
        );
      }
    }
  }

  void _pickAvatar(String currentName) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (file == null || !mounted) {
      return;
    }

    context.read<ProfileBloc>().add(
      UpdateProfile(name: currentName, avatar: file),
    );
  }

  Future<void> loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      appVersion = info.version;
    });
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
        ? 650.0
        : 700.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            AppSnackbar.show(context, message: state.message);

            // Load updated profile after successful update.
            context.read<ProfileBloc>().add(const LoadProfile());
          }

          if (state is ProfileFailure) {
            AppSnackbar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          String name = 'User';
          String email = 'abc123@gmail.com';

          if (state is ProfileLoaded) {
            name = state.profile.name ?? 'User';
            email = state.profile.email ?? 'abc123@gmail.com';
            avatarUrl = state.profile.avatarUrl;
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(const LoadProfile());
            },
            child: LiquidGlassBackground(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    const AppAuthBackground(height: 250),

                    SafeArea(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              isMobile ? 16 : 24,
                              horizontalPadding,
                              isMobile ? 120 : 36,
                            ),
                          child: Column(
                            children: [
                              AppHeader(
                                title: 'Profile',
                                isMobile: isMobile,
                                onBack: widget.onBack,
                              ),

                              SizedBox(height: isMobile ? 24 : 30),

                              ProfileCard(
                                name: name,
                                email: email,
                                avatarUrl: avatarUrl,
                                isMobile: isMobile,
                                onAvatarTap: () {
                                  _pickAvatar(name);
                                },
                              ),

                              const SizedBox(height: 24),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Account Settings',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : AppColors.ink,
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
                                    extra: name,
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

                              if (_isBiometricSupported) ...[
                                ProfileOption(
                                  icon: Icons.fingerprint,
                                  title: 'Fingerprint Login',
                                  subtitle: _isBiometricEnabled
                                      ? 'Enabled for this device'
                                      : 'Use biometric to log in to Spendly',
                                  trailing: Switch.adaptive(
                                    value: _isBiometricEnabled,
                                    activeTrackColor: const Color(0xFF1B7A70),
                                    onChanged: (value) =>
                                        _toggleBiometric(value, email),
                                  ),
                                  onTap: () => _toggleBiometric(
                                    !_isBiometricEnabled,
                                    email,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

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

                              BlocBuilder<ThemeCubit, ThemeMode>(
                                builder: (context, themeMode) {
                                  final isDark = themeMode == ThemeMode.dark;
                                  return ProfileOption(
                                    icon: isDark
                                        ? Icons.dark_mode_rounded
                                        : Icons.light_mode_rounded,
                                    title: 'Appearance',
                                    subtitle: isDark
                                        ? 'Dark Obsidian Glass'
                                        : 'Light Luminous Glass',
                                    trailing: const LiquidThemeToggle(size: 38),
                                    onTap: () {
                                      context.read<ThemeCubit>().toggleTheme();
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 12),

                              ProfileOption(
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                subtitle: 'Sign out from your account',
                                iconColor: AppColors.danger,
                                titleColor: AppColors.danger,
                                onTap: () async {
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Logout'),
                                        content: const Text(
                                          'Are you sure you want to logout?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                false,
                                              );
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                true,
                                              );
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldLogout == true && context.mounted) {
                                    context.push(RoutesName.logout);
                                  }
                                },
                              ),

                              const SizedBox(height: 28),

                              VersionTile(appVersion: appVersion),
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
        );
        },
      ),
    );
  }
}
