import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class ReceiptErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ReceiptErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  static const Color primary = Color(0xFF0F766E);
  static const Color danger = Color(0xFFE11D48);
  static const Color mutedText = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    danger.withValues(alpha: 0.16),
                    const Color(0xFFFB7185).withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: danger.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: danger.withValues(alpha: 0.14),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: danger,
                size: 38,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Unable to load receipts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 22),

            LiquidGlassButton(
              onPressed: onRetry,
              height: 44,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F766E),
                  Color(0xFF0D9488),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
