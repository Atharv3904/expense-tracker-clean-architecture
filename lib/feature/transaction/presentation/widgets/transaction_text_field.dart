import 'package:flutter/material.dart';
import 'transaction_form_panel.dart';

class TransactionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? prefixText;
  final int maxLines;
  final TextInputType? keyboardType;
  final double iconVerticalOffset;
  final String? Function(String?)? validator;

  const TransactionTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType,
    this.iconVerticalOffset = 0,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTeal = isDark ? const Color(0xFF2DD4BF) : TransactionWidgetPalette.teal;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDark ? Colors.white : TransactionWidgetPalette.ink,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.45)
              : TransactionWidgetPalette.ink.withValues(alpha: 0.38),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: isDark ? Colors.white : TransactionWidgetPalette.ink,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
        prefixIcon: Transform.translate(
          offset: Offset(0, iconVerticalOffset),
          child: Padding(
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
