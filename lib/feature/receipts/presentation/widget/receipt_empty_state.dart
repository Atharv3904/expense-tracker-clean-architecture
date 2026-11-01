import 'package:flutter/material.dart';

class ReceiptEmptyState extends StatelessWidget {
  final bool isSearching;

  const ReceiptEmptyState({super.key, required this.isSearching});

  static const Color primary = Color(0xFF0F766E);
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
                    primary.withValues(alpha: 0.16),
                    const Color(0xFF14B8A6).withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: primary.withValues(alpha: 0.22),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 38,
                color: Color(0xFF2DD4BF),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'No receipts found',
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
                isSearching
                    ? 'Try searching with a different name or merchant.'
                    : 'Upload your first receipt to see it here with instant optical analysis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
