import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final bool isMobile;

  const LoginHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: isMobile ? 72 : 82,
          height: isMobile ? 72 : 82,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF134E4A),
                      Color(0xFF0F766E),
                    ]
                  : const [
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
                color: const Color(0xFF14B8A6).withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF1B7A70),
            size: isMobile ? 36 : 42,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Spendly',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Welcome back, log in to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: isMobile ? 14 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
