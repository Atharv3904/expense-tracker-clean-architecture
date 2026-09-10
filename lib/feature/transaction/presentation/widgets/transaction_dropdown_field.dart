import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData icon;
  final Map<String, String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const TransactionDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final validValue = items.containsValue(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: validValue,

      isExpanded: true,

      hint: Text(hintText),

      items: items.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Text(entry.key),
        );
      }).toList(),

      onChanged: onChanged,

      validator: validator,

      decoration: InputDecoration(
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
