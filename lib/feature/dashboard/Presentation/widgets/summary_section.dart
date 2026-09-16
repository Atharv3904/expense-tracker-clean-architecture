import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  final bool isMobile;
  final double income;
  final double expense;

  const SummarySection({
    super.key,
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
