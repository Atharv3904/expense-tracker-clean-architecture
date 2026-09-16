import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/balance_card.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_top_background.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/summary_section.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/transactions_panel.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  final double balance;
  final double income;
  final double expense;

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    }

    if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    }

    if (hour >= 17 && hour < 21) {
      return 'Good evening';
    }

    return 'Good night';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final isTablet = Responsive.isTablet(context);
        final isDesktop = Responsive.isDesktop(context);

        final horizontalPadding = isMobile
            ? 18.0
            : isTablet
            ? 30.0
            : 34.0;

        final maxContentWidth = isDesktop ? 1180.0 : double.infinity;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              const DashboardTopBackground(),

              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        isMobile ? 18 : 24,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardHeader(
                            greeting: _getGreeting(),
                            isMobile: isMobile,
                          ),

                          SizedBox(height: isMobile ? 22 : 28),

                          BalanceCard(balance: balance, isMobile: isMobile),

                          const SizedBox(height: 18),

                          SummarySection(
                            isMobile: isMobile,
                            income: income,
                            expense: expense,
                          ),

                          const SizedBox(height: 26),

                          TransactionsPanel(isMobile: isMobile),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
