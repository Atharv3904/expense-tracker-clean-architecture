import 'package:expense_tracker/feature/authentication/presentation/widgets/field_icon.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required String labelText,
  required String hintText,
  required IconData icon,
  Widget? suffixIcon,
  bool isDark = false,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: isDark ? Colors.white70 : const Color(0xFF0F172A).withValues(alpha: 0.65),
      fontWeight: FontWeight.w600,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: isDark ? Colors.white.withValues(alpha: 0.45) : const Color(0xFF64748B).withValues(alpha: 0.65),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 14, right: 10),
      child: FieldIcon(icon: icon),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.85),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.9),
        width: 1.2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE2E8F0),
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFF1B7A70), width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFF43F5E)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.8),
    ),
  );
}
