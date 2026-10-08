import 'package:expense_tracker/core/colors/app_color.dart';

import 'package:flutter/material.dart';

class ReceiptUpload extends StatelessWidget {
  final VoidCallback onUpload;
  final String value;

  const ReceiptUpload({super.key, required this.onUpload, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onUpload,
        icon
        // isLoading
        //     ? const SizedBox(
        //         width: 20,
        //         height: 20,
        //         child: CircularProgressIndicator(
        //           color: Colors.white,
        //           strokeWidth: 2,
        //         ),
        //       )
        : const Icon(
          Icons.upload_file_rounded,
        ),
        label: Text(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColor.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
