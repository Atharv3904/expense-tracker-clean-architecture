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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      fileSize,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B9292),
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
                  color: Color(0xFFE0524A),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF7D8585),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
