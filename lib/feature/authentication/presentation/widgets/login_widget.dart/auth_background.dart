import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/header_ring.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 260,
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
                child: HeaderRing(size: 132),
              ),
              const Positioned(
                top: 44,
                right: -40,
                child: HeaderRing(size: 128),
              ),
              const Positioned(top: 92, left: 96, child: HeaderRing(size: 64)),
            ],
          ),
        ),
      ],
    );
  }
}
