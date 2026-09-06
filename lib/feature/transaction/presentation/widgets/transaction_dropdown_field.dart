import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData icon;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;

  const TransactionDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final validValue = items.any((item) => item.value == value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: validValue,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: TransactionWidgetPalette.muted,
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      items: items,
      onChanged: onChanged,
    );
  }
}
