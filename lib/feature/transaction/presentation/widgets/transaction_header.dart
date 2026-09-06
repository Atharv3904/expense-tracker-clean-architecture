import 'package:flutter/material.dart';

class TransactionHeader extends StatelessWidget {
  final String title;
  final bool isMobile;
  final VoidCallback? onBack;
  final Widget? trailing;

  const TransactionHeader({
    super.key,
    required this.title,
    required this.isMobile,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center title
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // Right-side widget
          if (trailing != null) Positioned(right: 0, child: trailing!),

          // Back button, if you decide to use i
        ],
      ),
    );
  }
}
