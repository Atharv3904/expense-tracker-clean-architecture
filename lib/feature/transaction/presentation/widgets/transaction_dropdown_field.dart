import 'package:flutter/material.dart';
import 'transaction_form_panel.dart';

class TransactionDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData icon;
  final Map<String, String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const TransactionDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTeal = isDark ? const Color(0xFF2DD4BF) : TransactionWidgetPalette.teal;
    final validValue = items.containsValue(value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: validValue,
      isExpanded: true,
      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: primaryTeal,
      ),
      style: TextStyle(
        color: isDark ? Colors.white : TransactionWidgetPalette.ink,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
      hint: Text(
        hintText,
        style: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.45)
              : TransactionWidgetPalette.ink.withValues(alpha: 0.38),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      items: items.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Text(
            entry.key,
            style: TextStyle(
              color: isDark ? Colors.white : TransactionWidgetPalette.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 10),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryTeal.withValues(alpha: isDark ? 0.18 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryTeal, size: 18),
          ),
        ),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.70)
            : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: primaryTeal,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: TransactionWidgetPalette.expense),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: TransactionWidgetPalette.expense, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
    );
  }
}
