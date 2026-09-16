import 'package:flutter/material.dart';

class FieldIcon extends StatelessWidget {
  final IconData icon;

  const FieldIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF2B8F84).withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF2B8F84), size: 18),
    );
  }
}
