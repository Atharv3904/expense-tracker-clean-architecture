import 'dart:ui';
import 'package:flutter/material.dart';
import 'transaction_form_panel.dart';

class TransactionTile extends StatelessWidget {
  final String description;
  final dynamic amount;
  final bool isMobile;
  final VoidCallback onTap;
  final String? receiptUrl;
  final VoidCallback? onReceiptTap;

  const TransactionTile({
    super.key,
    required this.description,
    required this.amount,
    required this.isMobile,
    required this.onTap,
    this.receiptUrl,
    this.onReceiptTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? Colors.white : TransactionWidgetPalette.ink;
    final hasReceipt = receiptUrl != null && receiptUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 14 : 16,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.72)
                    : Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : const Color(0xFF64748B).withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 48 : 52,
                    height: isMobile ? 48 : 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE6F7F5),
                          Color(0xFFCCFBF1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2DD4BF).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: TransactionWidgetPalette.teal,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ink,
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Transaction record',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ink.withValues(alpha: 0.5),
                          ),
                        ),

                        if (hasReceipt) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: onReceiptTap,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: TransactionWidgetPalette.teal.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: TransactionWidgetPalette.teal.withValues(alpha: 0.2),
                                  width: 0.8,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attachment_rounded,
                                    size: 12,
                                    color: TransactionWidgetPalette.teal,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Receipt Attached',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: TransactionWidgetPalette.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹$amount',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 17,
                          fontWeight: FontWeight.w900,
                          color: TransactionWidgetPalette.income,
                          letterSpacing: -0.3,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: TransactionWidgetPalette.ink.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
