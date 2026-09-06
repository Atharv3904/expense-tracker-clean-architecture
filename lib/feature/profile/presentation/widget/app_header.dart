import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool isMobile;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    required this.isMobile,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
        ],
      ),
    );
  }
}
