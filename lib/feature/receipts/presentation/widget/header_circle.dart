import 'package:flutter/material.dart';

class HeaderCircle extends StatelessWidget {
  final double size;

  const HeaderCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.11),
          width: 1.4,
        ),
      ),
    );
  }
}
