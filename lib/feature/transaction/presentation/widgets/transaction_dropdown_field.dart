import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'transaction_form_panel.dart';

class TransactionDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData icon;
  final Map<String, String> items;
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
    final validValue = items.containsValue(value) ? value : null;

    return FSelect<String>(
      hint: hintText,

      items: items,

      control: FSelectControl.managed(initial: validValue, onChange: onChanged),

      // 👇 Icon INSIDE the dropdown field
      prefixBuilder: (context, style, _) {
        return Container(
          width: 60,
          height: 34,
          decoration: BoxDecoration(
            color: TransactionWidgetPalette.teal.withValues(alpha: 0.11),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: TransactionWidgetPalette.teal, size: 18),
        );
      },
    );
  }
}
