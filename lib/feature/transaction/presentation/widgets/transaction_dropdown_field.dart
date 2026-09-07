import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'transaction_form_panel.dart';

class TransactionDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData icon;

  // Display name → ID
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
    return Row(
      children: [
        // Icon
        Container(
          width: 34,
          height: 34,
          margin: const EdgeInsets.only(left: 12, right: 10),
          decoration: BoxDecoration(
            color: TransactionWidgetPalette.teal.withValues(alpha: 0.11),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: TransactionWidgetPalette.teal, size: 18),
        ),

        // Forui Dropdown
        Expanded(
          child: FSelect<String>(
            hint: hintText,

            // Dropdown items
            items: items,

            // Selected value + onChanged
            control: FSelectControl.managed(
              initial: value,
              onChange: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
