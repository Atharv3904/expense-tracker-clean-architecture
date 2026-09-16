import 'package:expense_tracker/feature/transaction/presentation/widgets/chart_card.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/period_pill.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseChart extends StatelessWidget {
  final double income;
  final double expense;
  final bool isMobile;

  const IncomeExpenseChart({
    super.key,
    required this.income,
    required this.expense,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final hasIncome = income > 0;
    final hasExpense = expense > 0;
    final hasNoData = !hasIncome && !hasExpense;

    final maxValue = income > expense ? income : expense;
    final maxY = maxValue == 0 ? 100.0 : maxValue * 1.2;

    return ChartCard(
      title: 'Income vs Expense',
      trailing: const PeriodPill(text: 'Total'),
      height: 520,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          minY: 0,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: TransactionWidgetPalette.border,
                strokeWidth: 1,
                dashArray: [6, 6],
              );
            },
          ),

          borderData: FlBorderData(show: false),

          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => TransactionWidgetPalette.ink,
              tooltipRoundedRadius: 14,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = group.x == 0 ? 'Income' : 'Expense';

                return BarTooltipItem(
                  '$label\n₹${rod.toY.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),
          ),

          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: hasIncome ? income : 0,
                  width: isMobile ? 44 : 56,
                  color: hasIncome
                      ? TransactionWidgetPalette.income
                      : TransactionWidgetPalette.muted,
                  borderRadius: BorderRadius.circular(18),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: hasNoData
                        ? TransactionWidgetPalette.muted.withValues(alpha: 0.25)
                        : TransactionWidgetPalette.softMint,
                  ),
                ),
              ],
            ),

            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: hasExpense ? expense : 0,
                  width: isMobile ? 44 : 56,
                  color: hasExpense
                      ? TransactionWidgetPalette.expense
                      : TransactionWidgetPalette.muted,
                  borderRadius: BorderRadius.circular(18),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: hasNoData
                        ? TransactionWidgetPalette.muted.withValues(alpha: 0.25)
                        : TransactionWidgetPalette.softRed,
                  ),
                ),
              ],
            ),
          ],

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  final text = value.toInt() == 0 ? 'Income' : 'Expense';

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: TransactionWidgetPalette.muted,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: TransactionWidgetPalette.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),

            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }
}
