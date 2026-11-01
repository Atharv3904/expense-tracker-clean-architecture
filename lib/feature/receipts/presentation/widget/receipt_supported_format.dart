import 'package:flutter/material.dart';

class ReceiptSupportedFormat extends StatelessWidget {
  const ReceiptSupportedFormat({super.key});

  static const Color _primary = Color(0xFF238E84);
  static const Color _mutedText = Color(0xFF8B9292);
  static const Color _border = Color(0xFFE2EAEA);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.6)
            : const Color(0xFFF6FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : _border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark ? const Color(0xFF2DD4BF) : _primary,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Supported: PDF, JPG, JPEG, PNG and WEBP',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : _mutedText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
