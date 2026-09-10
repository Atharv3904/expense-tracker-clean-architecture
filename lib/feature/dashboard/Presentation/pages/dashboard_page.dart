import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_states.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/balance_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/dashboard_header.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/dashboard_top_background.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/summary_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widgets/transactions_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    return RefreshIndicator(
      color: DashboardPalettes.teal,
      onRefresh: () async {
        context.read<DashboardCubit>().dashboardSummary();
        context.read<TransactionBloc>().add(LoadTransaction());
        await Future<void>.value();
      },
      child: Scaffold(
        backgroundColor: DashboardPalettes.bg,
        body: BlocBuilder<DashboardCubit, DashboardStates>(
          builder: (context, state) {
            double balance = 0;
            double income = 0;
            double expense = 0;

            if (state is DashboardLoaded) {
              balance = state.summary.balance;
              income = state.summary.totalIncome;
              expense = state.summary.totalExpense;
            }

            return _buildDashboard(
              context,
              balance: balance,
              income: income,
              expense: expense,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context, {
    required double balance,
    required double income,
    required double expense,
  }) {
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

                          _SummarySection(
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

class _SummarySection extends StatelessWidget {
  final bool isMobile;
  final double income;
  final double expense;

  const _SummarySection({
    required this.isMobile,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          SummaryCard(
            title: 'Income',
            amount: income,
            icon: Icons.arrow_downward_rounded,
            color: DashboardPalettes.income,
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: 'Expense',
            amount: expense,
            icon: Icons.arrow_upward_rounded,
            color: DashboardPalettes.expense,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Income',
            amount: income,
            icon: Icons.arrow_downward_rounded,
            color: DashboardPalettes.income,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: 'Expense',
            amount: expense,
            icon: Icons.arrow_upward_rounded,
            color: DashboardPalettes.expense,
          ),
        ),
      ],
    );
  }
}
