import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionSectionLabel extends StatelessWidget {
  final String text;

  const TransactionSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        color: isDark ? Colors.white : TransactionWidgetPalette.ink,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    );
  }
}
