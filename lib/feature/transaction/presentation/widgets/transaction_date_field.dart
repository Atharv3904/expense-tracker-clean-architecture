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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTeal = isDark ? const Color(0xFF2DD4BF) : TransactionWidgetPalette.teal;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF0F172A).withValues(alpha: 0.70)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryTeal.withValues(alpha: isDark ? 0.18 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                color: primaryTeal,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '${selectedDate.day.toString().padLeft(2, '0')} / '
              '${selectedDate.month.toString().padLeft(2, '0')} / '
              '${selectedDate.year}',
              style: TextStyle(
                color: isDark ? Colors.white : TransactionWidgetPalette.ink,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: primaryTeal,
            ),
          ],
        ),
      ),
    );
  }
}
