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
    final hasReceipt = receiptUrl != null && receiptUrl!.isNotEmpty;

    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 18,
            vertical: isMobile ? 13 : 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: TransactionWidgetPalette.border),
            boxShadow: [
              BoxShadow(
                color: TransactionWidgetPalette.ink.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isMobile ? 48 : 52,
                height: isMobile ? 48 : 52,
                decoration: const BoxDecoration(
                  color: TransactionWidgetPalette.softMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: TransactionWidgetPalette.teal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: TransactionWidgetPalette.ink,
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Transaction amount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: TransactionWidgetPalette.muted,
                      ),
                    ),

                    if (hasReceipt)
                      TextButton.icon(
                        onPressed: onReceiptTap,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.visibility_rounded, size: 15),
                        label: const Text(
                          'View Receipt',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Text(
                '₹$amount',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w900,
                  color: TransactionWidgetPalette.income,
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: TransactionWidgetPalette.muted,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
