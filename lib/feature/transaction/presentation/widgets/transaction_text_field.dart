import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
    return FTextField(
      control: FTextFieldControl.managed(controller: controller),

      hint: prefixText != null ? '$prefixText$hintText' : hintText,

      maxLines: maxLines,

      keyboardType: keyboardType,

      prefixBuilder: (context, style, _) {
        return Padding(
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
        );
      },
    );
  }
}
