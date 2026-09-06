import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionSectionLabel extends StatelessWidget {
  final String text;

  const TransactionSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: TransactionWidgetPalette.ink,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    );
  }
}
