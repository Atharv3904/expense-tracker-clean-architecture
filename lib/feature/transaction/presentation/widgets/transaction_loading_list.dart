import 'package:flutter/material.dart';

import 'transaction_form_panel.dart';

class TransactionLoadingList extends StatelessWidget {
  final int itemCount;

  const TransactionLoadingList({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: 78,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: TransactionWidgetPalette.border,
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
