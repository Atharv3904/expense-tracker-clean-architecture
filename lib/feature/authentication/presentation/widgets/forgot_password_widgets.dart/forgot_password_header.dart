import 'package:flutter/material.dart';

class ForgotPasswordHeader extends StatelessWidget {
  final bool isMobile;
  final Color teal;
  final Color ink;
  final Color muted;

  const ForgotPasswordHeader({
    super.key,
    required this.isMobile,
    required this.teal,
    required this.ink,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isMobile ? 68 : 78,
          height: isMobile ? 68 : 78,
          decoration: BoxDecoration(
            color: teal.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            color: teal,
            size: isMobile ? 35 : 42,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Expense Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ink,
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ink,
            fontSize: isMobile ? 19 : 22,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Enter your email and we will send you a password reset link.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: isMobile ? 13 : 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
