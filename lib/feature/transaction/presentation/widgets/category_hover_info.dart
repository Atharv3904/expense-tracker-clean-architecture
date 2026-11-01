import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryHoverInfo extends StatelessWidget {
  final String category;
  final double amount;
  final Color color;
  final NumberFormat formatter;

  const CategoryHoverInfo({
    super.key,
    required this.category,
    required this.amount,
    required this.color,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.28),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --------------------------------------------------
          // COLOR INDICATOR
          // --------------------------------------------------
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 8),

          // --------------------------------------------------
          // CATEGORY NAME
          // --------------------------------------------------
          Text(
            category,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : TransactionWidgetPalette.ink,
            ),
          ),

          const SizedBox(width: 10),

          // --------------------------------------------------
          // AMOUNT
          // --------------------------------------------------
          Text(
            '₹${formatter.format(amount)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
