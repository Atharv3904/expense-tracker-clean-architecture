import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:flutter/material.dart';

class PeriodPill extends StatelessWidget {
  final String text;

  const PeriodPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: TransactionWidgetPalette.teal.withValues(alpha: isDark ? 0.22 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TransactionWidgetPalette.tealLight.withValues(alpha: isDark ? 0.45 : 0.28),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? const Color(0xFF2DD4BF) : TransactionWidgetPalette.teal,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
