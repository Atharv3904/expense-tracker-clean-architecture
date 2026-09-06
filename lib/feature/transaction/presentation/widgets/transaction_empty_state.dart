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
    return Center(
      child: Container(
        margin: const EdgeInsets.all(18),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: TransactionWidgetPalette.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: TransactionWidgetPalette.teal, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: TransactionWidgetPalette.ink,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
