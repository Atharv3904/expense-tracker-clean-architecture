import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/category_expense_chart.dart';

import 'package:expense_tracker/feature/transaction/presentation/widgets/income_expense_chart.dart';
import 'package:flutter/material.dart';

class ResponsiveCharts extends StatelessWidget {
  final double income;
  final double expense;
  final Map<String, double> categoryExpenses;
  final bool isMobile;

  const ResponsiveCharts({
    super.key,
    required this.income,
    required this.expense,
    required this.categoryExpenses,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final categoryChart = CategoryExpenseChart(
      categoryExpenses: categoryExpenses,
      isMobile: isMobile,
    );

    final incomeExpenseChart = IncomeExpenseChart(
      income: income,
      expense: expense,
      isMobile: isMobile,
    );

    if (isMobile || Responsive.isTablet(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          incomeExpenseChart,

          const SizedBox(height: 18),

          categoryChart,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: incomeExpenseChart),

        const SizedBox(width: 20),

        Expanded(
          child: CategoryExpenseChart(
            categoryExpenses: categoryExpenses,
            isMobile: false,
          ),
        ),
      ],
    );
  }
}
