import 'package:expense_tracker/feature/transaction/presentation/widgets/chart_card.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/legend_chip.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryExpenseChart extends StatefulWidget {
  final Map<String, double> categoryExpenses;
  final bool isMobile;

  const CategoryExpenseChart({
    super.key,
    required this.categoryExpenses,
    required this.isMobile,
  });

  @override
  State<CategoryExpenseChart> createState() => _CategoryExpenseChartState();
}

class _CategoryExpenseChartState extends State<CategoryExpenseChart> {
  int touchedSectionIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.categoryExpenses.values.fold<double>(
      0,
      (previous, amount) => previous + amount,
    );

    final entries = widget.categoryExpenses.entries.toList();

    return ChartCard(
      title: 'Spending by Category',
      trailing: const Icon(
        Icons.pie_chart_rounded,
        color: TransactionWidgetPalette.teal,
      ),
      height: 520,
      child: widget.categoryExpenses.isEmpty
          ? const Center(child: Text('No expense data available'))
          : Column(
              children: [
                // ==========================================================
                // PIE CHART
                // ==========================================================
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: widget.isMobile ? 48 : 58,
                      startDegreeOffset: -90,

                      // ======================================================
                      // TAP ONLY
                      // ======================================================
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback:
                            (FlTouchEvent event, PieTouchResponse? response) {
                              // Ignore hover / drag / move events.
                              if (event is! FlTapUpEvent) {
                                return;
                              }

                              // Tap outside the pie.
                              if (response?.touchedSection == null) {
                                if (touchedSectionIndex != -1) {
                                  setState(() {
                                    touchedSectionIndex = -1;
                                  });
                                }
                                return;
                              }

                              final newIndex =
                                  response!.touchedSection!.touchedSectionIndex;

                              setState(() {
                                touchedSectionIndex = newIndex;
                              });
                            },
                      ),

                      // ======================================================
                      // PIE SECTIONS
                      // ======================================================
                      sections: List.generate(entries.length, (index) {
                        final entry = entries[index];

                        final isTouched = index == touchedSectionIndex;

                        final percent = total == 0
                            ? 0
                            : ((entry.value / total) * 100).round();

                        final normalRadius = widget.isMobile ? 72.0 : 86.0;

                        final selectedRadius = widget.isMobile ? 86.0 : 102.0;

                        return PieChartSectionData(
                          value: entry.value,

                          // Percentage remains inside the pie.
                          title: '$percent%',

                          radius: isTouched ? selectedRadius : normalRadius,

                          color: _getCategoryColor(entry.key),

                          titleStyle: TextStyle(
                            fontSize: isTouched ? 15 : 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),

                          borderSide: isTouched
                              ? const BorderSide(color: Colors.white, width: 2)
                              : BorderSide.none,
                        );
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ==========================================================
                // CATEGORY LIST
                // ==========================================================
                Wrap(
                  spacing: 25,
                  runSpacing: 10,
                  children: List.generate(entries.length, (index) {
                    final entry = entries[index];

                    final isSelected = index == touchedSectionIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          touchedSectionIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,

                        // The LegendChip NEVER moves.
                        // It stays exactly in its original position.
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                          // Hover/selected effect.
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _getCategoryColor(
                                      entry.key,
                                    ).withValues(alpha: 0.30),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,

                          border: isSelected
                              ? Border.all(
                                  color: _getCategoryColor(
                                    entry.key,
                                  ).withValues(alpha: 0.55),
                                  width: 1.5,
                                )
                              : null,
                        ),

                        child: LegendChip(
                          label: entry.key,
                          amount: entry.value,
                          color: _getCategoryColor(entry.key),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
    );
  }

  // ================================================================
  // CATEGORY COLORS
  // ================================================================

  Color _getCategoryColor(String category) {
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
