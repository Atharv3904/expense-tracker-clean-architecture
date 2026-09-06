import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? prefixText;
  final int maxLines;
  final TextInputType? keyboardType;

  const TransactionTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: TransactionWidgetPalette.ink,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: TransactionWidgetPalette.ink,
          fontWeight: FontWeight.w900,
        ),
        hintStyle: TextStyle(
          color: TransactionWidgetPalette.muted.withValues(alpha: 0.78),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
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
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: TransactionWidgetPalette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: TransactionWidgetPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: TransactionWidgetPalette.teal,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
