import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/pages/dashboard_page.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/pages/profile_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/financial_insights_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _MainNavPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const softMint = Color(0xFFEAF8F5);
}

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
    if (index == 0) {
      context.read<TransactionBloc>().add(const LoadTransaction());
      context.read<DashboardCubit>().dashboardSummary();
    }

    if (index == 1) {
      context.read<TypeBloc>().add(const GetTypesTransaction());
      context.read<CategoryBloc>().add(const GetCategoryTransaction());
    }

    if (index == 2) {
      context.read<TransactionBloc>().add(const GetAllTransaction());
      context.read<TypeBloc>().add(const GetTypesTransaction());
      context.read<CategoryBloc>().add(const GetCategoryTransaction());
    }

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
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              title: const Text(
                'Exit App',
                style: TextStyle(
                  color: _MainNavPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: const Text(
                'Are you sure you want to exit?',
                style: TextStyle(
                  color: _MainNavPalette.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      color: _MainNavPalette.teal,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: _MainNavPalette.bg,
        extendBody: isMobile,
        body: Row(
          children: [
            if (isTablet && !isDesktop)
              _TabletNavigationRail(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              ),
            if (isDesktop)
              _DesktopNavigationSidebar(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              ),
            Expanded(
              child: IndexedStack(index: currentIndex, children: pages),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? _FloatingBottomNavigation(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              )
            : null,
      ),
    );
  }
}

class _FloatingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _FloatingBottomNavigation({
    required this.currentIndex,
    required this.onChanged,
  });

  static const items = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
    _NavItem(Icons.add_circle_outline_rounded, Icons.add_circle_rounded, 'Add'),
    _NavItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Insights'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.86)),
          boxShadow: [
            BoxShadow(
              color: _MainNavPalette.ink.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            for (int index = 0; index < items.length; index++)
              Expanded(
                child: _BottomNavButton(
                  item: items[index],
                  selected: currentIndex == index,
                  onTap: () => onChanged(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _MainNavPalette.teal : _MainNavPalette.muted;

    return Material(
      color: selected ? _MainNavPalette.softMint : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: color,
                size: 23,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
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

class _TabletNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _TabletNavigationRail({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.96),
      child: NavigationRail(
        backgroundColor: Colors.transparent,
        selectedIndex: currentIndex,
        onDestinationSelected: onChanged,
        labelType: NavigationRailLabelType.all,
        indicatorColor: _MainNavPalette.softMint,
        selectedIconTheme: const IconThemeData(color: _MainNavPalette.teal),
        unselectedIconTheme: const IconThemeData(color: _MainNavPalette.muted),
        selectedLabelTextStyle: const TextStyle(
          color: _MainNavPalette.teal,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: _MainNavPalette.muted,
          fontWeight: FontWeight.w700,
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: Text('Dashboard'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: Text('Add'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: Text('Insights'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: Text('Profile'),
          ),
        ],
      ),
    );
  }
}

class _DesktopNavigationSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _DesktopNavigationSidebar({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _MainNavPalette.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: _MainNavPalette.softMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: _MainNavPalette.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Expense Tracker',
                      style: TextStyle(
                        color: _MainNavPalette.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _DesktopNavigationItem(
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    selected: currentIndex == 0,
                    onTap: () => onChanged(0),
                  ),
                  _DesktopNavigationItem(
                    icon: Icons.add_circle_outline_rounded,
                    selectedIcon: Icons.add_circle_rounded,
                    label: 'Add Transaction',
                    selected: currentIndex == 1,
                    onTap: () => onChanged(1),
                  ),
                  _DesktopNavigationItem(
                    icon: Icons.bar_chart_outlined,
                    selectedIcon: Icons.bar_chart_rounded,
                    label: 'Financial Insights',
                    selected: currentIndex == 2,
                    onTap: () => onChanged(2),
                  ),
                  _DesktopNavigationItem(
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                    selected: currentIndex == 3,
                    onTap: () => onChanged(3),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _MainNavPalette.softMint,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Your money, in perspective.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _MainNavPalette.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? _MainNavPalette.softMint : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  color: selected
                      ? _MainNavPalette.teal
                      : _MainNavPalette.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? _MainNavPalette.teal
                          : _MainNavPalette.ink,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
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

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem(this.icon, this.selectedIcon, this.label);
}
