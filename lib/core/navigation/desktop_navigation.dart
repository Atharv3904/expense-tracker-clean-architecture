// ============================================================
// DESKTOP NAVIGATION
// ============================================================

import 'dart:ui';
import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesktopNavigationSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const DesktopNavigationSidebar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 270,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            border: Border(
              right: BorderSide(
                color: Colors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.ink.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 28),

                // Brand Header with Liquid Glass badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColor.tealLight,
                              AppColor.teal,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.teal.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spendly',
                              style: TextStyle(
                                color: AppColor.ink,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Expense Tracker',
                              style: TextStyle(
                                color: AppColor.muted,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Nav items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _DesktopNavigationItem(
                        icon: Icons.dashboard_outlined,
                        selectedIcon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        selected: currentIndex == 0,
                        onTap: () => onChanged(0),
                      ),

                      _DesktopNavigationItem(
                        icon: Icons.add_circle_outline_rounded,
                        selectedIcon: Icons.add_circle_rounded,
                        label: 'Add Transaction',
                        selected: currentIndex == 1,
                        onTap: () => onChanged(1),
                      ),

                      _DesktopNavigationItem(
                        icon: Icons.bar_chart_outlined,
                        selectedIcon: Icons.bar_chart_rounded,
                        label: 'Financial Insights',
                        selected: currentIndex == 2,
                        onTap: () => onChanged(2),
                      ),

                      _DesktopNavigationItem(
                        icon: Icons.receipt_long_outlined,
                        selectedIcon: Icons.receipt_long_rounded,
                        label: 'Receipts',
                        selected: currentIndex == 3,
                        onTap: () => onChanged(3),
                      ),

                      _DesktopNavigationItem(
                        icon: Icons.person_outline_rounded,
                        selectedIcon: Icons.person_rounded,
                        label: 'Profile',
                        selected: currentIndex == 4,
                        onTap: () => onChanged(4),
                      ),
                    ],
                  ),
                ),

                // Bottom Pro tip glass card
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.softMint.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 1.2,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColor.teal,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Smart clean analytics',
                            style: TextStyle(
                              color: AppColor.teal,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DesktopNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColor.teal.withValues(alpha: 0.14),
                    AppColor.tealLight.withValues(alpha: 0.08),
                  ],
                )
              : null,
          border: selected
              ? Border.all(
                  color: AppColor.tealLight.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      selected ? selectedIcon : icon,
                      color: selected ? AppColor.teal : AppColor.muted,
                      size: 22,
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected ? AppColor.teal : AppColor.ink,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
