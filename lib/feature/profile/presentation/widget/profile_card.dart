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
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
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
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.softMint,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: isMobile ? 58 : 65,
                    backgroundColor: Colors.white,
                    child: avatarUrl != null
                        ? loading
                              ? Center(child: CircularProgressIndicator())
                              : ClipOval(
                                  child: Image.network(
                                    avatarUrl!,
                                    width: isMobile ? 116 : 130,
                                    height: isMobile ? 116 : 130,
                                    fit: BoxFit.cover,
                                  ),
                                )
                        : Icon(
                            Icons.person_rounded,
                            size: isMobile ? 58 : 65,
                            color: AppColors.teal,
                          ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink,
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
              color: AppColors.muted,
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
