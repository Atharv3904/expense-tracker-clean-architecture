import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionDateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const TransactionDateField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TransactionWidgetPalette.border),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: TransactionWidgetPalette.teal.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: TransactionWidgetPalette.teal,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${selectedDate.day}/'
              '${selectedDate.month}/'
              '${selectedDate.year}',
              style: const TextStyle(
                color: TransactionWidgetPalette.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: TransactionWidgetPalette.muted,
            ),
          ],
        ),
      ),
    );
  }
}
