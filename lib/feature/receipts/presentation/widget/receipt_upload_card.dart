import 'dart:ui';
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

  static const Color _primary = Color(0xFF1B7A70);
  static const Color _primaryLight = Color(0xFF2FB5A6);
  static const Color _mutedText = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : _primary.withValues(alpha: 0.10),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1B7A70).withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Upload icon with gradient
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0F766E),
                            Color(0xFF14B8A6),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE6F7F5),
                            Color(0xFFCCFBF1),
                          ],
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withValues(alpha: 0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud_upload_rounded,
                  color: isDark ? Colors.white : _primary,
                  size: 38,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Upload a Receipt',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                'Keep high-resolution PDF and image receipts attached to your transactions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : _mutedText,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // Supported formats
              const ReceiptSupportedFormat(),

              const SizedBox(height: 28),

              // Upload button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _primaryLight,
                      _primary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onUpload,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : const Icon(Icons.upload_file_rounded),
                  label: Text(
                    isLoading ? 'Uploading receipt...' : 'Choose Receipt',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // View all receipts
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: onViewAll,
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: const Text('View All Receipts'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? const Color(0xFF2DD4BF) : _primary,
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF2DD4BF).withValues(alpha: 0.45)
                          : _primary.withValues(alpha: 0.35),
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
