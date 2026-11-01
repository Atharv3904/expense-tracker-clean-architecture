import 'package:expense_tracker/core/colors/app_color.dart';
import 'package:flutter/material.dart';

class ReceiptUpload extends StatelessWidget {
  final VoidCallback onUpload;
  final String value;

  const ReceiptUpload({super.key, required this.onUpload, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tealColor = isDark ? const Color(0xFF2DD4BF) : AppColor.teal;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: tealColor.withValues(alpha: isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tealColor.withValues(alpha: isDark ? 0.35 : 0.28),
          width: 1.3,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onUpload,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tealColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.upload_file_rounded,
                    color: tealColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tealColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
