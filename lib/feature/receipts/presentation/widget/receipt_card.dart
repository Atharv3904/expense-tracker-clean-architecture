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
    required this.receipt,
    required this.fileIcon,
    required this.fileSize,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EAEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(fileIcon, color: const Color(0xFF238E84), size: 28),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${fileSize} • ${DateFormat('dd MMM yyyy').format(receipt.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF707A7A),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onView,
            tooltip: 'View receipt',
            icon: const Icon(Icons.visibility_outlined),
          ),

          IconButton(
            onPressed: onDelete,
            tooltip: 'Delete receipt',
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
