import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionTopBackground extends StatelessWidget {
  final double height;
  final double bottomRadius;

  const TransactionTopBackground({
    super.key,
    this.height = 245,
    this.bottomRadius = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            TransactionWidgetPalette.teal,
            TransactionWidgetPalette.tealDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -44,
            left: -34,
            child: _TransactionHeaderRing(size: 132),
          ),
          Positioned(
            top: 42,
            right: -38,
            child: _TransactionHeaderRing(size: 126),
          ),
          Positioned(
            top: 82,
            left: 86,
            child: _TransactionHeaderRing(size: 64),
          ),
        ],
      ),
    );
  }
}

class _TransactionHeaderRing extends StatelessWidget {
  final double size;

  const _TransactionHeaderRing({required this.size});

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
