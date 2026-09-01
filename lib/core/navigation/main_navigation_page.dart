import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/pages/dashboard_page.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/pages/profile_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/financial_insights_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;
  final List<int> navigationHistory = [0];

  final List<Widget> pages = const [
    DashboardPage(),
    AddTransactionPage(),
    FinancialInsightsPage(),
    ProfilePage(),
  ];

  void _loadPageData(int index) {
    // Dashboard
    if (index == 0) {
      context.read<TransactionBloc>().add(const LoadTransaction());

      context.read<DashboardCubit>().dashboardSummary();
    }

    // Add Transaction
    if (index == 1) {
      context.read<TransactionBloc>().add(const GetTypesTransaction());

      context.read<TransactionBloc>().add(const GetCategoryTransaction());
    }

    // Financial Insights
    if (index == 2) {
      context.read<TransactionBloc>().add(const GetAllTransaction());
    }

    // Profile
    if (index == 3) {
      context.read<ProfileBloc>().add(const LoadProfile());
    }
  }

  void _onNavigationChanged(int index) {
    if (index == currentIndex) _loadPageData(currentIndex);

    setState(() {
      navigationHistory.add(index);
      currentIndex = index;
    });

    // Dashboard
    _loadPageData(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (navigationHistory.length > 1) {
          setState(() {
            navigationHistory.removeLast();
            currentIndex = navigationHistory.last;
          });
          return;
        }

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        );
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
        // We'll write the actual exit handling next.
      },

      child: Scaffold(
        body: Row(
          children: [
            if (isTablet)
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _onNavigationChanged,

                labelType: NavigationRailLabelType.all,

                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add_circle_outline),
                    selectedIcon: Icon(Icons.add_circle),
                    label: Text('Add'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: Text('Insights'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),

            if (isDesktop)
              Container(
                width: 240,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // App Logo / Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Expense Tracker',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Navigation items
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _DesktopNavigationItem(
                            icon: Icons.dashboard_outlined,
                            selectedIcon: Icons.dashboard,
                            label: 'Dashboard',
                            selected: currentIndex == 0,
                            onTap: () {
                              _onNavigationChanged(0);
                            },
                          ),

                          _DesktopNavigationItem(
                            icon: Icons.add_circle_outline,
                            selectedIcon: Icons.add_circle,
                            label: 'Add Transaction',
                            selected: currentIndex == 1,
                            onTap: () {
                              _onNavigationChanged(1);
                            },
                          ),

                          _DesktopNavigationItem(
                            icon: Icons.bar_chart_outlined,
                            selectedIcon: Icons.bar_chart,
                            label: 'Financial Insights',
                            selected: currentIndex == 2,
                            onTap: () {
                              _onNavigationChanged(2);
                            },
                          ),

                          _DesktopNavigationItem(
                            icon: Icons.person_outline,
                            selectedIcon: Icons.person,
                            label: 'Profile',
                            selected: currentIndex == 3,
                            onTap: () {
                              _onNavigationChanged(3);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Bottom section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Expense Tracker',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: IndexedStack(index: currentIndex, children: pages),
            ),
          ],
        ),

        bottomNavigationBar: isMobile
            ? NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: _onNavigationChanged,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.add_circle_outline),
                    selectedIcon: Icon(Icons.add_circle),
                    label: 'Add',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: 'Insights',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class _DesktopNavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DesktopNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,

          selected: selected,

          selectedTileColor: colorScheme.primaryContainer,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          leading: Icon(
            selected ? selectedIcon : icon,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),

          title: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
