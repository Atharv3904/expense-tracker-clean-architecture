import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String description;
  final dynamic amount;
  final VoidCallback onTap;
  final String? receiptUrl;
  final VoidCallback? onReceiptTap;

  const TransactionCard({
    super.key,
    required this.description,
    required this.amount,
    required this.onTap,
    this.receiptUrl,
    this.onReceiptTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    const ink = Color(0xFF07091D);
    const accentColor = Color(0xFF22C55E);

    final hasReceipt = receiptUrl != null && receiptUrl!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 18,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: ink.withValues(alpha: 0.055)),
            boxShadow: [
              BoxShadow(
                color: ink.withValues(alpha: 0.045),
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
                decoration: BoxDecoration(
                  color: const Color(0xFFB8F4F1).withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: ink,
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
                        color: ink,
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Transaction amount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
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
                  color: accentColor,
                ),
              ),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
