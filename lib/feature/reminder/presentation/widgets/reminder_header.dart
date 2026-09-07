import 'package:flutter/material.dart';

class ReminderHeader extends StatelessWidget {
  const ReminderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Reminders',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
