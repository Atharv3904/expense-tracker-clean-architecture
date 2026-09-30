import 'package:flutter/material.dart';

class ReceiptSupportedFormat extends StatelessWidget {
  const ReceiptSupportedFormat({super.key});

  static const Color _primary = Color(0xFF238E84);
  static const Color _mutedText = Color(0xFF8B9292);
  static const Color _border = Color(0xFFE2EAEA);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _primary, size: 20),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Supported: PDF, JPG, JPEG, PNG and WEBP',
              style: TextStyle(color: _mutedText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
