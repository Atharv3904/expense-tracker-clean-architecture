import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_top_background.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget block({double height = 16, double? width, double radius = 18}) {
      return Shimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: DashboardPalettes.border,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    return Stack(
      children: [
        const DashboardTopBackground(),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              block(height: 16, width: 120),
              const SizedBox(height: 8),
              block(height: 30, width: 220),
              const SizedBox(height: 28),
              block(height: 156, radius: 30),
              const SizedBox(height: 18),
              block(height: 86, radius: 24),
              const SizedBox(height: 12),
              block(height: 86, radius: 24),
              const SizedBox(height: 26),
              block(height: 230, radius: 30),
            ],
          ),
        ),
      ],
    );
  }
}
