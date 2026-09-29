import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/today_income_expense_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/category_expense_chart.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/today_income_expense_chart.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/income_expense_chart.dart';
import 'package:flutter/widgets.dart';

class ResponsiveCharts extends StatelessWidget {
  final double income;
  final double expense;
  final Map<String, double> categoryExpenses;
  final List<TodayIncomeExpenseEntity> dailyIncomeExpense;
  final bool isMobile;

  const ResponsiveCharts({
    super.key,
    required this.income,
    required this.expense,
    required this.categoryExpenses,
    required this.dailyIncomeExpense,
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

    final dailyChart = TodayIncomeExpenseChart(
      data: dailyIncomeExpense,
      isMobile: isMobile,
    );

    // Mobile + Tablet
    if (isMobile || Responsive.isTablet(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          incomeExpenseChart,

          const SizedBox(height: 18),

          dailyChart,

          const SizedBox(height: 18),

          categoryChart,
        ],
      );
    }

    // Desktop
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: incomeExpenseChart),

            const SizedBox(width: 20),

            Expanded(child: categoryChart),
          ],
        ),

        const SizedBox(height: 20),

        dailyChart,
      ],
    );
  }
}
