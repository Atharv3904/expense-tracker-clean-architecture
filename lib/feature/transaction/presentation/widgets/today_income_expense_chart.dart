// ignore_for_file: depend_on_referenced_packages

import 'package:expense_tracker/feature/transaction/domain/entities/today_income_expense_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/chart_card.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/legend_item.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/period_pill.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayIncomeExpenseChart extends StatelessWidget {
  final List<TodayIncomeExpenseEntity> data;
  final bool isMobile;

  const TodayIncomeExpenseChart({
    super.key,
    required this.data,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------
    // NO TRANSACTIONS
    // ------------------------------------------------------------
    if (data.isEmpty) {
      return ChartCard(
        title: "Today's Income vs Expense",
        trailing: const PeriodPill(text: 'Today'),
        height: 420,
        child: const Center(child: Text("No transactions today")),
      );
    }

    // ------------------------------------------------------------
    // FIND MAX VALUE
    // ------------------------------------------------------------
    final maxValue = data.fold<double>(0, (max, item) {
      final highest = item.income > item.expense ? item.income : item.expense;

      return highest > max ? highest : max;
    });

    final maxY = maxValue == 0 ? 100.0 : maxValue * 1.2;

    // ------------------------------------------------------------
    // NUMBER FORMAT
    // Example:
    // 1000   -> 1,000
    // 10000  -> 10,000
    // ------------------------------------------------------------
    final formatter = NumberFormat.decimalPattern('en_IN');

    // ------------------------------------------------------------
    // INCOME SPOTS
    // ------------------------------------------------------------
    final List<FlSpot> incomeSpots = [];

    double previousIncome = 0;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      if (item.income != previousIncome) {
        incomeSpots.add(FlSpot(i.toDouble(), item.income));

        previousIncome = item.income;
      }
    }

    // ------------------------------------------------------------
    // EXPENSE SPOTS
    // ------------------------------------------------------------
    final List<FlSpot> expenseSpots = [];

    double previousExpense = 0;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      if (item.expense != previousExpense) {
        expenseSpots.add(FlSpot(i.toDouble(), item.expense));

        previousExpense = item.expense;
      }
    }

    // ------------------------------------------------------------
    // CHART
    // ------------------------------------------------------------
    return ChartCard(
      title: "Today's Income vs Expense",
      trailing: const PeriodPill(text: 'Today'),
      height: 460,
      child: Column(
        children: [
          // --------------------------------------------------------
          // LEGEND
          // --------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(
                color: TransactionWidgetPalette.income,
                text: 'Income',
              ),

              const SizedBox(width: 24),

              LegendItem(color: Colors.red, text: 'Expense'),
            ],
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------------
          // CHART + CENTERED DATE
          // --------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                // --------------------------------------------------
                // LINE CHART
                // --------------------------------------------------
                Expanded(
                  child: LineChart(
                    LineChartData(
                      // ------------------------------------------------
                      // Y AXIS
                      // ------------------------------------------------
                      minY: 0,
                      maxY: maxY,

                      // ------------------------------------------------
                      // X AXIS
                      // ------------------------------------------------
                      minX: 0,
                      maxX: data.length > 1 ? (data.length - 1).toDouble() : 1,

                      // ------------------------------------------------
                      // GRID
                      // ------------------------------------------------
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

                      // ------------------------------------------------
                      // BORDER
                      // ------------------------------------------------
                      borderData: FlBorderData(show: false),

                      // ------------------------------------------------
                      // TOUCH
                      // ------------------------------------------------
                      lineTouchData: LineTouchData(
                        // Remove vertical touch line
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.transparent,
                                    strokeWidth: 0,
                                  ),
                                  FlDotData(show: true),
                                );
                              }).toList();
                            },

                        // ------------------------------------------------
                        // TOOLTIP
                        // ------------------------------------------------
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => TransactionWidgetPalette.ink,
                          tooltipRoundedRadius: 14,

                          getTooltipItems: (touchedSpots) {
                            if (touchedSpots.isEmpty) {
                              return [];
                            }

                            final index = touchedSpots.first.x.toInt();

                            if (index < 0 || index >= data.length) {
                              return [];
                            }

                            final item = data[index];

                            final time = DateFormat('h:mm a').format(item.time);

                            return [
                              LineTooltipItem(
                                '$time\n'
                                'Income: ₹${formatter.format(item.income)}\n'
                                'Expense: ₹${formatter.format(item.expense)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                            ];
                          },
                        ),
                      ),

                      // ------------------------------------------------
                      // TITLES
                      // ------------------------------------------------
                      titlesData: FlTitlesData(
                        // TOP
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        // RIGHT
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        // LEFT
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 65,
                            interval: maxY / 4,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                formatter.format(value.toInt()),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: TransactionWidgetPalette.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),

                        // BOTTOM
                        //
                        // We don't show the date through fl_chart.
                        // The date is placed separately below the chart
                        // so it stays exactly centered.
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),

                      // ------------------------------------------------
                      // LINES
                      // ------------------------------------------------
                      lineBarsData: [
                        // ------------------------------------------------
                        // INCOME LINE
                        // ------------------------------------------------
                        if (incomeSpots.isNotEmpty)
                          LineChartBarData(
                            spots: incomeSpots,
                            color: TransactionWidgetPalette.income,
                            barWidth: 3,

                            // Smooth wave
                            isCurved: true,
                            curveSmoothness: 0.55,

                            isStrokeCapRound: true,

                            // Income dots
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: TransactionWidgetPalette.income,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          ),

                        // ------------------------------------------------
                        // EXPENSE LINE
                        // ------------------------------------------------
                        if (expenseSpots.isNotEmpty)
                          LineChartBarData(
                            spots: expenseSpots,
                            color: Colors.red,
                            barWidth: 3,

                            // Smooth wave
                            isCurved: true,
                            curveSmoothness: 0.55,

                            isStrokeCapRound: true,

                            // Expense dots
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: Colors.red,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ------------------------------------------------------
                // TODAY'S DATE
                // ------------------------------------------------------
                const SizedBox(height: 8),

                Center(
                  child: Text(
                    DateFormat('d MMM yyyy').format(DateTime.now()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: TransactionWidgetPalette.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
