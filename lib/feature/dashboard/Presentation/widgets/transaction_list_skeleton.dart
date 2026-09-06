import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class TransactionListSkeleton extends StatelessWidget {
  const TransactionListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == 2 ? 0 : 10),
          child: Shimmer(
            child: Container(
              height: 74,
              decoration: BoxDecoration(
                color: DashboardPalettes.border,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        );
      }),
    );
  }
}
