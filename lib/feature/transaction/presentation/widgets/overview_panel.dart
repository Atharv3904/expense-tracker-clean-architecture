import 'dart:ui';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? Colors.white : TransactionWidgetPalette.ink;
    final balance = income - expense;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF1B7A70).withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1B7A70).withValues(alpha: 0.10)
                    : ink.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Financial Overview',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : TransactionWidgetPalette.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (balance >= 0
                              ? TransactionWidgetPalette.income
                              : TransactionWidgetPalette.expense)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      balance >= 0 ? '+ Positive' : '- Deficit',
                      style: TextStyle(
                        color: balance >= 0
                            ? TransactionWidgetPalette.income
                            : TransactionWidgetPalette.expense,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: ink,
                  fontSize: isMobile ? 36 : 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1.05,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 18),
              if (isMobile)
                Column(
                  children: [
                    MetricTile(
                      title: 'Total Income',
                      amount: income,
                      icon: Icons.arrow_downward_rounded,
                      color: TransactionWidgetPalette.income,
                    ),
                    const SizedBox(height: 10),
                    MetricTile(
                      title: 'Total Expense',
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
                        title: 'Total Income',
                        amount: income,
                        icon: Icons.arrow_downward_rounded,
                        color: TransactionWidgetPalette.income,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: MetricTile(
                        title: 'Total Expense',
                        amount: expense,
                        icon: Icons.arrow_upward_rounded,
                        color: TransactionWidgetPalette.expense,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
