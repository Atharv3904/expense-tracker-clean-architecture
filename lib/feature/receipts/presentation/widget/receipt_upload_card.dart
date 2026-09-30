import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_supported_format.dart';
import 'package:flutter/material.dart';

class ReceiptUploadCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onUpload;
  final VoidCallback onViewAll;

  const ReceiptUploadCard({
    super.key,
    required this.isLoading,
    required this.onUpload,
    required this.onViewAll,
  });

  static const Color _primary = Color(0xFF238E84);
  static const Color _mintSurface = Color(0xFFE5F5F2);
  static const Color _mutedText = Color(0xFF8B9292);
  static const Color _border = Color(0xFFE2EAEA);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Upload icon
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: _mintSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: _primary,
              size: 36,
            ),
          ),

          const SizedBox(height: 18),

          // Title
          const Text(
            'Upload a receipt',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          // Description
          const Text(
            'Save your PDF and image receipts with your expense records.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _mutedText, fontSize: 14, height: 1.4),
          ),

          const SizedBox(height: 22),

          // Supported formats
          const ReceiptSupportedFormat(),

          const SizedBox(height: 24),

          // Upload button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onUpload,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(
                isLoading ? 'Uploading receipt...' : 'Choose Receipt',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // View all receipts
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onViewAll,
              icon: const Icon(Icons.receipt_long_rounded),
              label: const Text('View All Receipts'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                side: const BorderSide(color: _primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
