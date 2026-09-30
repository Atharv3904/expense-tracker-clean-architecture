import 'package:flutter/material.dart';

class ReceiptErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ReceiptErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  static const Color primary = Color(0xFF238E84);
  static const Color danger = Color(0xFFE0524A);
  static const Color mutedText = Color(0xFF8B9292);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: danger, size: 52),

            const SizedBox(height: 16),

            const Text(
              'Unable to load receipts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: mutedText),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
