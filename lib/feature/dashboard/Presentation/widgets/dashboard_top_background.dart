import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/header_bubble.dart';
import 'package:flutter/material.dart';

class DashboardTopBackground extends StatelessWidget {
  const DashboardTopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DashboardPalettes.teal, DashboardPalettes.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -42, left: -28, child: HeaderBubble(size: 130)),
          Positioned(top: 42, right: -34, child: HeaderBubble(size: 120)),
          Positioned(top: 84, left: 88, child: HeaderBubble(size: 62)),
        ],
      ),
    );
  }
}
