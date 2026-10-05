// ============================================================
// DESKTOP NAVIGATION
// ============================================================

import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:flutter/material.dart';

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
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColor.bg,
        border: Border(right: BorderSide(color: AppColor.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 26),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppColor.softMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppColor.teal,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Expense Tracker',
                      style: TextStyle(
                        color: AppColor.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 34),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
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

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColor.softMint,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Your money, in perspective.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
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
      child: Material(
        color: selected ? AppColor.softMint : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  color: selected ? AppColor.teal : AppColor.muted,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? AppColor.teal : AppColor.ink,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
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
