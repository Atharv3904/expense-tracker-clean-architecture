import 'dart:ui';
import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:expense_tracker/core/navigation/desktop_navigation.dart';
import 'package:expense_tracker/core/navigation/liquid_glass_navigation.dart';
// import 'package:expense_tracker/core/navigation/mobile_navigation.dart';
import 'package:expense_tracker/core/navigation/tablet_navigation.dart';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/presentation/pages/dashboard_page.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';

import 'package:expense_tracker/feature/profile/presentation/pages/profile_page.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_bloc.dart';
import 'package:expense_tracker/feature/receipts/presentation/pages/receipt_page.dart';
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

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<int> navigationHistory = [0];

  void _goBack() {
    if (navigationHistory.length > 1) {
      setState(() {
        navigationHistory.removeLast();
        currentIndex = navigationHistory.last;
      });
    }
  }

  late final List<Widget> pages = [
    DashboardPage(),

    AddTransactionPage(onBack: _goBack),

    FinancialInsightsPage(onBack: _goBack),

    ReceiptPage(onBack: _goBack),

    ProfilePage(onBack: _goBack),
  ];

  void _loadPageData(int index) {
    // Dashboard
    if (index == 0) {
      context.read<TransactionBloc>().add(const LoadTransaction());

      context.read<DashboardCubit>().dashboardSummary();
    }

    // Add Transaction
    if (index == 1) {
      context.read<TransactionBloc>().add(const GetAllTransaction());

      context.read<TypeBloc>().add(const GetTypesTransaction());

      context.read<CategoryBloc>().add(const GetCategoryTransaction());
    }

    // Financial Insights
    if (index == 2) {
      context.read<TransactionBloc>().add(const GetAllTransaction());

      context.read<TypeBloc>().add(const GetTypesTransaction());

      context.read<CategoryBloc>().add(const GetCategoryTransaction());
    }

    // Receipts
    if (index == 3) {
      context.read<ReceiptBloc>();
    }

    // Profile
    if (index == 4) {
      context.read<ProfileBloc>();
    }
  }

  void _onNavigationChanged(int index) {
    if (index == currentIndex) {
      return;
    }

    setState(() {
      navigationHistory.remove(index);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        if (navigationHistory.length > 1) {
          setState(() {
            navigationHistory.removeLast();
            currentIndex = navigationHistory.last;
          });

          return;
        }

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.16)
                        : Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                ),
                title: Text(
                  'Exit App',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColor.ink,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                content: Text(
                  'Are you sure you want to exit?',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : AppColor.muted,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : AppColor.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  LiquidGlassButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                    },
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gradient: const LinearGradient(
                      colors: [AppColor.teal, AppColor.tealLight],
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: isMobile,
        body: Row(
          children: [
            // Tablet navigation
            if (isTablet && !isDesktop)
              TabletNavigationRail(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              ),

            // Desktop navigation
            if (isDesktop)
              DesktopNavigationSidebar(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              ),

            // Page content
            Expanded(
              child: IndexedStack(index: currentIndex, children: pages),
            ),
          ],
        ),

        // Mobile navigation
        bottomNavigationBar: isMobile
            ? LiquidGlassBottomNavigation(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              )
            : null,
      ),
    );
  }
}
