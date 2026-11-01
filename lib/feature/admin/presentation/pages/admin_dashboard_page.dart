import 'dart:ui';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/admin/presentation/cubit/all_user_cubit.dart';
import 'package:expense_tracker/feature/admin/presentation/cubit/all_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<void> _showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Exit Spendly?'),
          content: const Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Exit', style: TextStyle(color: Color(0xFF1B7A70))),
            ),
          ],
        );
      },
    );

    if (shouldExit == true && context.mounted) {
      context.push(RoutesName.login);
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Yes', style: TextStyle(color: Color(0xFFF43F5E))),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      context.push(RoutesName.logout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllUserCubit, AllUserState>(
      listener: (context, state) {
        if (state is AllUserError) {
          AppSnackbar.show(context, message: state.message);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _showExitDialog(context);
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              tooltip: 'Exit',
              onPressed: () => _showExitDialog(context),
            ),
            title: const Text(
              'Spendly Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F4E47),
                    Color(0xFF1B7A70),
                    Color(0xFF2FB5A6),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
            ],
          ),
          body: LiquidGlassBackground(
            child: BlocBuilder<AllUserCubit, AllUserState>(
              builder: (context, state) {
                if (state is AllUserInitial || state is AllUserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1B7A70)),
                  );
                }

                if (state is AllUserError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Color(0xFFF43F5E),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Unable to load users',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          LiquidGlassButton(
                            width: 160,
                            height: 48,
                            onPressed: () {
                              context.read<AllUserCubit>().getAllUsers();
                            },
                            label: 'Try again',
                            icon: Icons.refresh_rounded,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is AllUserLoaded) {
                  final users = state.users;

                  return RefreshIndicator(
                    color: const Color(0xFF1B7A70),
                    onRefresh: () {
                      return context.read<AllUserCubit>().getAllUsers();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
                      children: [
                        // Admin Hero Header
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.90),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  width: 1.4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1B7A70).withValues(alpha: 0.10),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFE6F7F5), Color(0xFFCCFBF1)],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                                        width: 1.3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.admin_panel_settings_rounded,
                                      color: Color(0xFF1B7A70),
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Administrator',
                                          style: TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Overview & Members',
                                          style: TextStyle(
                                            color: Color(0xFF0F172A),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1B7A70).withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFF2FB5A6).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${users.length}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1B7A70),
                                          ),
                                        ),
                                        const Text(
                                          'Users',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1B7A70),
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

                        const SizedBox(height: 24),

                        const Text(
                          'Registered Users',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (users.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  size: 64,
                                  color: Color(0xFF94A3B8),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No users found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ...users.map((user) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.95),
                                      width: 1.3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF64748B).withValues(alpha: 0.06),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1B7A70).withValues(alpha: 0.12),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF2FB5A6).withValues(alpha: 0.3),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: Color(0xFF1B7A70),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name?.isNotEmpty == true
                                                  ? user.name!
                                                  : 'Name unavailable',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              user.email ?? 'No email',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: (user.role == 'admin'
                                                            ? const Color(0xFF6366F1)
                                                            : const Color(0xFF10B981))
                                                        .withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    (user.role ?? 'user').toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w800,
                                                      color: user.role == 'admin'
                                                          ? const Color(0xFF6366F1)
                                                          : const Color(0xFF10B981),
                                                    ),
                                                  ),
                                                ),
                                                if (user.created != null) ...[
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    user.created!.toLocal().toString().split(' ')[0],
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF94A3B8),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
