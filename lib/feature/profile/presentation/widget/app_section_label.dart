import 'package:flutter/material.dart';

class AppSectionLabel extends StatelessWidget {
  final String text;

  const AppSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontWeight: FontWeight.w900,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
    );
  }
}
