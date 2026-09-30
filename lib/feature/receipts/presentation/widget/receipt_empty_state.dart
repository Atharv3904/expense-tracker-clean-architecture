import 'package:flutter/material.dart';

class ReceiptEmptyState extends StatelessWidget {
  final bool isSearching;

  const ReceiptEmptyState({super.key, required this.isSearching});

  static const Color primary = Color(0xFF238E84);
  static const Color mutedText = Color(0xFF8B9292);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFE5F5F2),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 36,
                color: primary,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'No receipts found',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 7),

            Text(
              isSearching
                  ? 'Try searching with a different name.'
                  : 'Upload your first receipt to see it here.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: mutedText),
            ),
          ],
        ),
      ),
    );
  }
}
