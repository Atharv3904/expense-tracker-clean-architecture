import 'dart:ui';
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
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBack != null)
            Positioned(
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 19 : 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
