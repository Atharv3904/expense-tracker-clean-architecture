import 'dart:ui';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isMobile;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF0F172A);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 22 : 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xCC1E293B),
                      Color(0x990F172A),
                      Color(0xB31E293B),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xF5FFFFFF),
                      Color(0xE0F0FDFA),
                      Color(0xCCF8FAFC),
                    ],
                  ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF14B8A6).withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF14B8A6).withValues(alpha: 0.15)
                    : ink.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Atmospheric liquid glow orb
              Positioned(
                right: -24,
                top: -24,
                child: IgnorePointer(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF2DD4BF).withValues(alpha: isDark ? 0.20 : 0.35),
                          const Color(0xFF38BDF8).withValues(alpha: isDark ? 0.08 : 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Watermark wallet icon
              Positioned(
                right: 12,
                bottom: -20,
                child: IgnorePointer(
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    size: isMobile ? 105 : 125,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : const Color(0xFF1B7A70).withValues(alpha: 0.06),
                  ),
                ),
              ),

              // Balance information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF2DD4BF),
                                  Color(0xFF14B8A6),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF14B8A6).withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : ink.withValues(alpha: 0.65),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Active Net Worth',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF64748B)
                                          : ink.withValues(alpha: 0.45),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F766E).withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2DD4BF).withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.9),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 13,
                              color: isDark
                                  ? const Color(0xFF2DD4BF)
                                  : const Color(0xFF14B8A6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'INR',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFF2DD4BF)
                                    : ink.withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isMobile ? 20 : 24),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: ink,
                        fontSize: isMobile ? 40 : 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        height: 1,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
