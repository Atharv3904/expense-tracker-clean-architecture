import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final bool isMobile;

  const LoginHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isMobile ? 68 : 78,
          height: isMobile ? 68 : 78,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF8F5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: Color(0xFF2B8F84),
            size: isMobile ? 34 : 40,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Spendly',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF07091D),
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back, login to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF89918F),
            fontSize: isMobile ? 14 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
