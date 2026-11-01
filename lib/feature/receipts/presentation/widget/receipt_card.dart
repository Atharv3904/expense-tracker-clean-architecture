import 'dart:ui';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptCard extends StatelessWidget {
  final ReceiptEntity receipt;
  final IconData fileIcon;
  final String fileSize;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const ReceiptCard({
    super.key,
    required this.receipt,
    required this.fileIcon,
    required this.fileSize,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.88),
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
                width: 50,
                height: 50,
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
                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Icon(fileIcon, color: const Color(0xFF1B7A70), size: 24),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: const Color(0xFF64748B).withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMM yyyy').format(receipt.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onView,
                tooltip: 'View receipt',
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: Color(0xFF1B7A70),
                  size: 21,
                ),
              ),

              IconButton(
                onPressed: onDelete,
                tooltip: 'Delete receipt',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFF43F5E),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
