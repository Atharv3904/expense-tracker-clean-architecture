import 'package:expense_tracker/feature/transaction/presentation/widgets/chart_card.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/legend_chip.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryExpenseChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;
  final bool isMobile;

  const CategoryExpenseChart({
    super.key,
    required this.categoryExpenses,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final total = categoryExpenses.values.fold<double>(
      0,
      (previous, amount) => previous + amount,
    );

    return ChartCard(
      title: 'Spending by Category',
      trailing: const Icon(
        Icons.pie_chart_rounded,
        color: TransactionWidgetPalette.teal,
      ),
      height: 520,
      child: categoryExpenses.isEmpty
          ? const Center(child: Text('No expense data available'))
          : Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: isMobile ? 48 : 58,
                      startDegreeOffset: -90,
                      sections: categoryExpenses.entries.map((entry) {
                        final percent = total == 0
                            ? 0
                            : ((entry.value / total) * 100).round();

                        return PieChartSectionData(
                          value: entry.value,
                          title: '$percent%',
                          radius: isMobile ? 78 : 92,
                          color: _getCategoryColor(entry.key),
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Wrap(
                  spacing: 25,
                  runSpacing: 10,
                  children: categoryExpenses.entries.map((entry) {
                    return LegendChip(
                      label: entry.key,
                      amount: entry.value,
                      color: _getCategoryColor(entry.key),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }

  Color _getCategoryColor(String category) {
    // Move your existing _getCategoryColor() logic here.
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFFA24C);

      case 'shopping':
        return const Color(0xFF8B5CF6);

      case 'transport':
        return const Color(0xFF3B82F6);

      case 'healthcare':
        return const Color(0xFF22B573);

      case 'investment':
        return const Color.fromARGB(255, 45, 65, 2);

      case 'bills':
        return const Color(0xFFE8524A);

      case 'salary':
        return const Color.fromARGB(255, 221, 35, 238);

      default:
        return const Color(0xFF8A9693);
    }
  }
}
