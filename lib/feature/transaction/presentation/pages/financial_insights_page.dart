import 'package:expense_tracker/core/responsive/responsive.dart';

import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_header.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_top_background.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialInsightsPage extends StatefulWidget {
  const FinancialInsightsPage({super.key});

  @override
  State<FinancialInsightsPage> createState() => _FinancialInsightsPageState();
}

class _FinancialInsightsPageState extends State<FinancialInsightsPage> {
  String? incomeTypeId;
  String? expenseTypeId;

  List<TransactionCategoryEntity> categories = [];

  Map<String, double> _calculateCategoryExpenses(List transactions) {
    final Map<String, double> categoryExpenses = {};

    for (final transaction in transactions) {
      if (transaction.typeId != expenseTypeId) {
        continue;
      }

      TransactionCategoryEntity? category;

      for (final item in categories) {
        if (item.id == transaction.categoryId) {
          category = item;
          break;
        }
      }

      if (category == null) {
        continue;
      }

      categoryExpenses[category.name] =
          (categoryExpenses[category.name] ?? 0) + transaction.amount;
    }

    return categoryExpenses;
  }

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

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 900.0
        : 1180.0;

    return MultiBlocListener(
      listeners: [
        BlocListener<TypeBloc, TypeStates>(
          listener: (context, state) {
            if (state is TypeLoaded) {
              TransactionTypeEntity? income;
              TransactionTypeEntity? expense;

              for (final type in state.types) {
                if (type.type == 'income') {
                  income = type;
                }

                if (type.type == 'expense') {
                  expense = type;
                }
              }

              setState(() {
                incomeTypeId = income?.id;
                expenseTypeId = expense?.id;
              });
            }

            if (state is TypeFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<CategoryBloc, CategoryStates>(
          listener: (context, state) {
            if (state is CategoryLoaded) {
              setState(() {
                categories = state.categories;
              });
            }

            if (state is CategoryFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: TransactionWidgetPalette.bg,
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return _InsightsLoading();
            }

            if (state is TransactionFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: TransactionWidgetPalette.muted),
                ),
              );
            }

            if (state is TransactionLoaded) {
              double income = 0;
              double expense = 0;

              for (final transaction in state.transactions) {
                if (transaction.typeId == incomeTypeId) {
                  income += transaction.amount;
                }

                if (transaction.typeId == expenseTypeId) {
                  expense += transaction.amount;
                }
              }

              final categoryExpenses = _calculateCategoryExpenses(
                state.transactions,
              );

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    const TransactionTopBackground(
                      height: 245,
                      bottomRadius: 34,
                    ),
                    SafeArea(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              isMobile ? 16 : 24,
                              horizontalPadding,
                              28,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TransactionHeader(
                                  title: 'Financial Insights',
                                  isMobile: isMobile,
                                ),
                                SizedBox(height: isMobile ? 26 : 32),
                                _OverviewPanel(
                                  income: income,
                                  expense: expense,
                                  isMobile: isMobile,
                                ),
                                const SizedBox(height: 24),
                                _buildResponsiveCharts(
                                  context,
                                  income,
                                  expense,
                                  categoryExpenses,
                                  isMobile,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveCharts(
    BuildContext context,
    double income,
    double expense,
    Map<String, double> categoryExpenses,
    bool isMobile,
  ) {
    if (isMobile || Responsive.isTablet(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIncomeExpenseChart(income, expense, isMobile),
          const SizedBox(height: 18),
          _buildCategoryChart(categoryExpenses, isMobile),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildIncomeExpenseChart(income, expense, false)),
        const SizedBox(width: 20),
        Expanded(child: _buildCategoryChart(categoryExpenses, false)),
      ],
    );
  }

  Widget _buildIncomeExpenseChart(
    double income,
    double expense,
    bool isMobile,
  ) {
    final maxValue = income > expense ? income : expense;

    final maxY = maxValue == 0 ? 100.0 : maxValue * 1.2;

    return _ChartCard(
      title: 'Income vs Expense',
      trailing: const _PeriodPill(text: 'Total'),
      height: 460,
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
                  toY: income,
                  width: isMobile ? 44 : 56,
                  color: TransactionWidgetPalette.income,
                  borderRadius: BorderRadius.circular(18),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: TransactionWidgetPalette.softMint,
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: expense,
                  width: isMobile ? 44 : 56,
                  color: TransactionWidgetPalette.expense,
                  borderRadius: BorderRadius.circular(18),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: TransactionWidgetPalette.softRed,
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

  Widget _buildCategoryChart(
    Map<String, double> categoryExpenses,
    bool isMobile,
  ) {
    final total = categoryExpenses.values.fold<double>(
      0,
      (previous, amount) => previous + amount,
    );

    return _ChartCard(
      title: 'Spending by Category',
      trailing: const Icon(
        Icons.pie_chart_rounded,
        color: TransactionWidgetPalette.teal,
      ),
      height: 460,
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
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categoryExpenses.entries.map((entry) {
                    return _LegendChip(
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
}

class _OverviewPanel extends StatelessWidget {
  final double income;
  final double expense;
  final bool isMobile;

  const _OverviewPanel({
    required this.income,
    required this.expense,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: TransactionWidgetPalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: TransactionWidgetPalette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: TransactionWidgetPalette.ink,
              fontSize: isMobile ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _MetricTile(
                  title: 'Income',
                  amount: income,
                  icon: Icons.arrow_downward_rounded,
                  color: TransactionWidgetPalette.income,
                ),
                const SizedBox(height: 10),
                _MetricTile(
                  title: 'Expense',
                  amount: expense,
                  icon: Icons.arrow_upward_rounded,
                  color: TransactionWidgetPalette.expense,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: 'Income',
                    amount: income,
                    icon: Icons.arrow_downward_rounded,
                    color: TransactionWidgetPalette.income,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    title: 'Expense',
                    amount: expense,
                    icon: Icons.arrow_upward_rounded,
                    color: TransactionWidgetPalette.expense,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _MetricTile({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: TransactionWidgetPalette.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final double height;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.trailing,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: TransactionWidgetPalette.border),
        boxShadow: [
          BoxShadow(
            color: TransactionWidgetPalette.ink.withValues(alpha: 0.055),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: TransactionWidgetPalette.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              trailing,
            ],
          ),
          const SizedBox(height: 18),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _PeriodPill extends StatelessWidget {
  final String text;

  const _PeriodPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: TransactionWidgetPalette.softMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: TransactionWidgetPalette.teal,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _LegendChip({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: TransactionWidgetPalette.ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TransactionTopBackground(height: 245, bottomRadius: 34),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 330,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
