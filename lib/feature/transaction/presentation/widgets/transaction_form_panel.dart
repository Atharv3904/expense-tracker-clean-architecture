import 'dart:ui';
import 'package:flutter/material.dart';

class TransactionWidgetPalette {
  static const bg = Color(0xFFF1F5F9);
  static const teal = Color(0xFF1B7A70);
  static const tealDark = Color(0xFF0F4E47);
  static const tealLight = Color(0xFF2FB5A6);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFF43F5E);
  static const softMint = Color(0xFFE6F7F5);
  static const softRed = Color(0xFFFFEEEE);
}

class TransactionFormPanel extends StatelessWidget {
  final Widget child;

  const TransactionFormPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF1B7A70).withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1B7A70).withValues(alpha: 0.10)
                    : TransactionWidgetPalette.ink.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
