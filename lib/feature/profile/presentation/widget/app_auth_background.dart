import 'package:flutter/material.dart';

class AppAuthBackground extends StatelessWidget {
  final double height;

  const AppAuthBackground({super.key, this.height = 245});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B8F84), Color(0xFF19766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -42,
            left: -34,
            child: AppHeaderRing(size: 132),
          ),
          const Positioned(
            top: 42,
            right: -38,
            child: AppHeaderRing(size: 126),
          ),
          const Positioned(top: 86, left: 90, child: AppHeaderRing(size: 64)),
        ],
      ),
    );
  }
}

class AppHeaderRing extends StatelessWidget {
  final double size;

  const AppHeaderRing({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}
