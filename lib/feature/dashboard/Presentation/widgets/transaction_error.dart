import 'package:flutter/material.dart';

class TransactionError extends StatelessWidget {
  final String message;

  const TransactionError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF07091D);
    const danger = Color(0xFFE5484D);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: danger.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: danger.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: danger.withValues(alpha: 0.11),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: danger,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                message,
                style: TextStyle(
                  color: ink.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
