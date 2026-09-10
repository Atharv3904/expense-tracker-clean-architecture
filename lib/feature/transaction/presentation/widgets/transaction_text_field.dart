import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? prefixText;
  final int maxLines;
  final TextInputType? keyboardType;
  final double iconVerticalOffset;

  final String? Function(String?)? validator;

  const TransactionTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType,
    this.iconVerticalOffset = 0,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        hintText: hintText,

        prefixText: prefixText,

        prefixIcon: Transform.translate(
          offset: Offset(0, iconVerticalOffset),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 10),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: TransactionWidgetPalette.teal.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: TransactionWidgetPalette.teal, size: 18),
            ),
          ),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: TransactionWidgetPalette.teal,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
