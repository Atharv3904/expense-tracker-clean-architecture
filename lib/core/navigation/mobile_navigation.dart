// ============================================================
// MOBILE NAVIGATION
// ============================================================

import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:expense_tracker/core/navigation/nav_item.dart';
import 'package:flutter/material.dart';

class FloatingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FloatingBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  static const items = [
    NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
    NavItem(Icons.add_circle_outline_rounded, Icons.add_circle_rounded, 'Add'),
    NavItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Insights'),
    NavItem(
      Icons.receipt_long_outlined,
      Icons.receipt_long_rounded,
      'Receipts',
    ),
    NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.86)),
          boxShadow: [
            BoxShadow(
              color: AppColor.ink.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            for (int index = 0; index < items.length; index++)
              Expanded(
                child: _BottomNavButton(
                  item: items[index],
                  selected: currentIndex == index,
                  onTap: () => onChanged(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColor.teal : AppColor.muted;

    return Material(
      color: selected ? AppColor.softMint : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: color,
                size: 23,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
