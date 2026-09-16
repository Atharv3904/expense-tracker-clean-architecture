import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_section_label.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_text_field.dart';
import 'package:flutter/material.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;

  const AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TransactionSectionLabel('Amount'),

        const SizedBox(height: 10),

        TransactionTextField(
          controller: controller,
          hintText: 'Enter amount',
          prefixText: '${AppConstants.currencySymbol} ',
          icon: Icons.payments_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter amount';
            }

            final amount = double.tryParse(value.trim());

            if (amount == null) {
              return 'Please enter a valid amount';
            }

            if (amount <= 0) {
              return 'Amount must be greater than 0';
            }

            return null;
          },
        ),
      ],
    );
  }
}
