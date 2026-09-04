import 'dart:ui';

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isMobile;

  const BalanceCard({super.key, required this.balance, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF07091D);
    const mint = Color(0xFF9DF3EF);
    const cream = Color(0xFFFFF8EF);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: ink.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -38,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mint.withValues(alpha: 0.38),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: -26,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 118,
              color: ink.withValues(alpha: 0.045),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 20,
                      color: ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ink.withValues(alpha: 0.58),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: ink,
                    fontSize: isMobile ? 38 : 46,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                    height: 1,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
