import 'package:expense_tracker/feature/transaction/presentation/widgets/metric_tile.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:flutter/material.dart';

class OverviewPanel extends StatelessWidget {
  final double income;
  final double expense;
  final bool isMobile;

  const OverviewPanel({
    super.key,
    required this.income,
    required this.expense,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: TransactionWidgetPalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: TransactionWidgetPalette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: TransactionWidgetPalette.ink,
              fontSize: isMobile ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                MetricTile(
                  title: 'Income',
                  amount: income,
                  icon: Icons.arrow_downward_rounded,
                  color: TransactionWidgetPalette.income,
                ),
                const SizedBox(height: 10),
                MetricTile(
                  title: 'Expense',
                  amount: expense,
                  icon: Icons.arrow_upward_rounded,
                  color: TransactionWidgetPalette.expense,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: MetricTile(
                    title: 'Income',
                    amount: income,
                    icon: Icons.arrow_downward_rounded,
                    color: TransactionWidgetPalette.income,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricTile(
                    title: 'Expense',
                    amount: expense,
                    icon: Icons.arrow_upward_rounded,
                    color: TransactionWidgetPalette.expense,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
