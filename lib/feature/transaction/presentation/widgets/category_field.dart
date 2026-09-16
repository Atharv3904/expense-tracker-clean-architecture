import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_dropdown_field.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_section_label.dart';
import 'package:flutter/material.dart';

class CategoryField extends StatelessWidget {
  final String? value;
  final List<TransactionCategoryEntity> categories;
  final ValueChanged<String?> onChanged;

  const CategoryField({
    super.key,
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TransactionSectionLabel('Category'),

        const SizedBox(height: 10),

        TransactionDropdownField(
          value: value,
          hintText: 'Select category',
          icon: Icons.category_rounded,

          items: {
            for (final category in categories) category.name: category.id,
          },

          onChanged: onChanged,

          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select category';
            }

            return null;
          },
        ),
      ],
    );
  }
}
