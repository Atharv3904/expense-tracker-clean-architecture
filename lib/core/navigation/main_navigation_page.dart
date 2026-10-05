import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:expense_tracker/core/navigation/desktop_navigation.dart';
import 'package:expense_tracker/core/navigation/mobile_navigation.dart';
import 'package:expense_tracker/core/navigation/tablet_navigation.dart';
import 'package:expense_tracker/core/responsive/responsive.dart';
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
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              title: const Text(
                'Exit App',
                style: TextStyle(
                  color: AppColor.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: const Text(
                'Are you sure you want to exit?',
                style: TextStyle(
                  color: AppColor.muted,
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
                      color: AppColor.teal,
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
        backgroundColor: AppColor.bg,
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
            ? FloatingBottomNavigation(
                currentIndex: currentIndex,
                onChanged: _onNavigationChanged,
              )
            : null,
      ),
    );
  }
}
