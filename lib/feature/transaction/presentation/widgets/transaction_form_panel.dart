import 'package:flutter/material.dart';

class TransactionWidgetPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const income = Color(0xFF22B573);
  static const expense = Color(0xFFE8524A);
  static const softMint = Color(0xFFEAF8F5);
  static const softRed = Color(0xFFFFEEEE);
}

class TransactionFormPanel extends StatelessWidget {
  final Widget child;

  const TransactionFormPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: TransactionWidgetPalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}
