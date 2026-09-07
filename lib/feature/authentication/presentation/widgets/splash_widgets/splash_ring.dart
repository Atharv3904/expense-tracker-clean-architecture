import 'package:flutter/material.dart';

class SplashRing extends StatelessWidget {
  final double size;

  const SplashRing({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
    );
  }
}
