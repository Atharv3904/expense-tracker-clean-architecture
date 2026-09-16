import 'package:expense_tracker/feature/authentication/presentation/widgets/header_ring.dart';
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
              Positioned(top: -42, left: -34, child: HeaderRing(size: 132)),
              Positioned(top: 44, right: -40, child: HeaderRing(size: 128)),
              Positioned(top: 92, left: 96, child: HeaderRing(size: 64)),
            ],
          ),
        ),
      ],
    );
  }
}
