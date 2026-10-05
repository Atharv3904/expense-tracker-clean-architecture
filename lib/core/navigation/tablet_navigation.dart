// ============================================================
// TABLET NAVIGATION
// ============================================================

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
    return Container(
      color: AppColor.bg,
      child: NavigationRail(
        backgroundColor: Colors.transparent,
        selectedIndex: currentIndex,
        onDestinationSelected: onChanged,
        labelType: NavigationRailLabelType.all,
        indicatorColor: AppColor.softMint,
        selectedIconTheme: const IconThemeData(color: AppColor.teal),
        unselectedIconTheme: const IconThemeData(color: AppColor.muted),
        selectedLabelTextStyle: const TextStyle(
          color: AppColor.teal,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: AppColor.muted,
          fontWeight: FontWeight.w700,
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
    );
  }
}
