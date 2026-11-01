import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const TransactionEmptyState({
    super.key,
    this.message = 'No transactions found',
    this.icon = Icons.search_off_rounded,
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
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
                      TransactionWidgetPalette.teal.withValues(alpha: 0.16),
                      TransactionWidgetPalette.tealLight.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: TransactionWidgetPalette.teal.withValues(alpha: 0.22),
                  ),
                ),
                child: Icon(icon, color: TransactionWidgetPalette.teal, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : TransactionWidgetPalette.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
