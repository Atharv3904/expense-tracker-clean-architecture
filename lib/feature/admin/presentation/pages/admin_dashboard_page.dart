import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/admin/presentation/cubit/all_user_cubit.dart';
import 'package:expense_tracker/feature/admin/presentation/cubit/all_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllUserCubit, AllUserState>(
      listener: (context, state) {
        if (state is AllUserError) {
          AppSnackbar.show(context, message: state.message);
        }
        final user = Supabase.instance.client.auth.currentUser;

        debugPrint('Logged-in user ID: ${user?.id}');
        debugPrint('Logged-in email: ${user?.email}');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spendly Admin Dashboard'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
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
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<AllUserCubit, AllUserState>(
          builder: (context, state) {
            // Initial state
            if (state is AllUserInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // Loading state
            if (state is AllUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error state
            if (state is AllUserError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
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
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AllUserCubit>().getAllUsers();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Loaded state
            if (state is AllUserLoaded) {
              final users = state.users;

              return RefreshIndicator(
                onRefresh: () {
                  return context.read<AllUserCubit>().getAllUsers();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Admin welcome section
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.admin_panel_settings,
                      size: 64,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Welcome, Admin!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Total users card
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(
                          Icons.people,
                          color: Colors.teal,
                          size: 32,
                        ),
                        title: const Text('Total registered users'),
                        trailing: Text(
                          '${users.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Users section heading
                    const Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Empty state
                    if (users.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No users found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Display all users
                    ...users.map((user) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: const Icon(Icons.person, color: Colors.teal),
                          ),
                          title: Text(
                            user.name?.isNotEmpty == true
                                ? user.name!
                                : 'Name unavailable',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user.email ?? 'Not available'}'),
                                const SizedBox(height: 4),
                                Text(
                                  'Created at: ${user.created != null ? user.created!.toLocal().toString().split('.')[0] : 'Not available'}',
                                ),
                                const SizedBox(height: 4),
                                Text('Role: ${user.role ?? 'Not assigned'}'),
                              ],
                            ),
                          ),
                          isThreeLine: true,
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
    );
  }
}
