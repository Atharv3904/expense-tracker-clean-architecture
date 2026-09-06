import 'package:flutter/material.dart';

class AppSkeleton extends StatelessWidget {
  final double height;
  final double radius;

  const AppSkeleton({super.key, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEEB),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
