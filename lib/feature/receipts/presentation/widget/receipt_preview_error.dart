import 'package:flutter/material.dart';

class ReceiptPreviewError extends StatelessWidget {
  const ReceiptPreviewError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.white, size: 56),

          SizedBox(height: 12),

          Text(
            'Unable to load receipt',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
