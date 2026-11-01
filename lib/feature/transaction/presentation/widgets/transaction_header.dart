import 'dart:ui';
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onBack,
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
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Center title
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 19 : 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Right-side widget
          if (trailing != null) Positioned(right: 0, child: trailing!),
        ],
      ),
    );
  }
}
