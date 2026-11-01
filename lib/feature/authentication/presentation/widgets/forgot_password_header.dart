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
          width: isMobile ? 72 : 82,
          height: isMobile ? 72 : 82,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE6F7F5),
                Color(0xFFCCFBF1),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: teal.withValues(alpha: 0.20),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            color: teal,
            size: isMobile ? 36 : 42,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Spendly',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ink,
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ink,
            fontSize: isMobile ? 18 : 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Enter your email and we will send you a password reset link.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
