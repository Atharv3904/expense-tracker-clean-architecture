import 'package:flutter/material.dart';

class ForgotPasswordBackground extends StatelessWidget {
  final Color teal;
  final Color tealDark;

  const ForgotPasswordBackground({
    super.key,
    required this.teal,
    required this.tealDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [teal, tealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(38),
              bottomRight: Radius.circular(38),
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -42, left: -34, child: _HeaderRing(size: 132)),
              Positioned(top: 44, right: -40, child: _HeaderRing(size: 128)),
              Positioned(top: 92, left: 96, child: _HeaderRing(size: 64)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;

  const _HeaderRing({required this.size});

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
