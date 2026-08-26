// ignore_for_file: use_key_in_widget_constructors

import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String description;
  final dynamic amount;
  final VoidCallback onTap;

  const TransactionCard({
    required this.description,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 18,
          vertical: isMobile ? 6 : 8,
        ),

        // Transaction icon
        leading: Container(
          width: isMobile ? 42 : 46,
          height: isMobile ? 42 : 46,

          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),

          child: const Icon(Icons.receipt_long_outlined, color: Colors.green),
        ),

        // Description
        title: Text(
          description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Subtitle
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),

          child: Text(
            'Transaction amount',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),

        // Amount + arrow
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹$amount',

              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(width: 10),

            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),

        onTap: onTap,
      ),
    );
  }
}
