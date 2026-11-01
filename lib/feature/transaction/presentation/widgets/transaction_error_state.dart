import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionErrorState extends StatelessWidget {
  final String message;
  final String title;

  const TransactionErrorState({
    super.key,
    required this.message,
    this.title = 'Unable to load transactions',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LiquidGlassCard(
          blur: 20,
          borderRadius: BorderRadius.circular(32),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        TransactionWidgetPalette.expense.withValues(alpha: 0.16),
                        const Color(0xFFFB7185).withValues(alpha: 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: TransactionWidgetPalette.expense.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: TransactionWidgetPalette.expense,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : TransactionWidgetPalette.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TransactionWidgetPalette.muted,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.4,
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
