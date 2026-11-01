import 'package:flutter/material.dart';

class AppFieldIcon extends StatelessWidget {
  final IconData icon;

  const AppFieldIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teal = isDark ? const Color(0xFF2DD4BF) : const Color(0xFF1B7A70);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: teal.withValues(alpha: isDark ? 0.18 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: teal, size: 18),
    );
  }
}
