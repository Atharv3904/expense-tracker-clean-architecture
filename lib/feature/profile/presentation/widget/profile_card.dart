import 'dart:ui';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final bool isMobile;
  final String? avatarUrl;
  final VoidCallback onAvatarTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.isMobile,
    required this.onAvatarTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 30,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.95),
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
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF1B7A70).withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1B7A70).withValues(alpha: 0.10)
                    : AppColors.ink.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final loading = (state is ProfileLoading);
                  return GestureDetector(
                    onTap: onAvatarTap,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2DD4BF),
                                Color(0xFF14B8A6),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF14B8A6).withValues(alpha: 0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: isMobile ? 54 : 62,
                            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                            child: avatarUrl != null
                                ? loading
                                    ? const Center(child: CircularProgressIndicator())
                                    : ClipOval(
                                        child: Image.network(
                                          avatarUrl!,
                                          width: isMobile ? 108 : 124,
                                          height: isMobile ? 108 : 124,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                : Icon(
                                    Icons.person_rounded,
                                    size: isMobile ? 54 : 62,
                                    color: isDark ? const Color(0xFF2DD4BF) : AppColors.teal,
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.ink,
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F766E).withValues(alpha: 0.25)
                      : AppColors.teal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2DD4BF).withValues(alpha: 0.35)
                        : AppColors.tealLight.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF2DD4BF) : AppColors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
