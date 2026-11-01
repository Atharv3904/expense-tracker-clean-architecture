import 'dart:ui';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:flutter/material.dart';

class ReceiptListCard extends StatelessWidget {
  final ReceiptEntity receipt;
  final String fileSize;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const ReceiptListCard({
    super.key,
    required this.receipt,
    required this.fileSize,
    required this.icon,
    required this.iconColor,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(26),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.72)
                    : Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(26),
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
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipt.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          fileSize,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: onDelete,
                    tooltip: 'Delete receipt',
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFF43F5E),
                      size: 22,
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF94A3B8),
                    size: 24,
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
