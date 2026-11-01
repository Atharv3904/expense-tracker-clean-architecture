// ============================================================
// TABLET NAVIGATION
// ============================================================

import 'dart:ui';
import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:flutter/material.dart';

class TabletNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const TabletNavigationRail({
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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            border: Border(
              right: BorderSide(
                color: Colors.white.withValues(alpha: 0.85),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.ink.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            selectedIndex: currentIndex,
            onDestinationSelected: onChanged,
            labelType: NavigationRailLabelType.all,
            indicatorColor: AppColor.teal.withValues(alpha: 0.15),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: AppColor.tealLight.withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
            selectedIconTheme: const IconThemeData(
              color: AppColor.teal,
              size: 24,
            ),
            unselectedIconTheme: const IconThemeData(
              color: AppColor.muted,
              size: 22,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: AppColor.teal,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: AppColor.muted,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.tealLight, AppColor.teal],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.teal.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline_rounded),
                selectedIcon: Icon(Icons.add_circle_rounded),
                label: Text('Add'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded),
                label: Text('Insights'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded),
                label: Text('Receipts'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
