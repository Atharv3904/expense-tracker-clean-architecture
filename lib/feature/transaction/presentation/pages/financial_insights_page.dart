import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
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

  @override
  void initState() {
    super.initState();

    context.read<TransactionBloc>().add(const GetTypesTransaction());

    context.read<TransactionBloc>().add(const GetCategoryTransaction());
  }

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
        return Colors.orange;

      case 'shopping':
        return Colors.purple;

      case 'transport':
        return Colors.blue;

      case 'healthcare':
        return Colors.green;

      case 'investment':
        return Colors.indigo;

      case 'bills':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 16.0 : 24.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 900.0
        : 1400.0;

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TypeLoaded) {
          final income = state.types
              .where((type) => type.type == 'income')
              .firstOrNull;

          final expense = state.types
              .where((type) => type.type == 'expense')
              .firstOrNull;

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

      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),

        appBar: AppBar(
          title: const Text(
            'Financial Insights',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFF7F7FA),
          elevation: 0,
        ),

        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransactionFailure) {
              return Center(child: Text(state.message));
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
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),

                    child: _buildResponsiveCharts(
                      context,
                      income,
                      expense,
                      categoryExpenses,
                      isMobile,
                    ),
                  ),
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
    // MOBILE / TABLET
    if (isMobile || Responsive.isTablet(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIncomeExpenseChart(income, expense, isMobile),

          const SizedBox(height: 28),

          _buildCategoryChart(categoryExpenses, isMobile),
        ],
      );
    }

    // DESKTOP
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildIncomeExpenseChart(income, expense, false)),

        const SizedBox(width: 24),

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Income vs Expense',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,

          height: isMobile ? 300 : 360,

          padding: EdgeInsets.all(isMobile ? 12 : 20),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,

              maxY: maxY,

              minY: 0,

              gridData: FlGridData(
                show: true,

                drawVerticalLine: false,

                horizontalInterval: maxY / 5,
              ),

              borderData: FlBorderData(show: false),

              barGroups: [
                BarChartGroupData(
                  x: 0,

                  barRods: [
                    BarChartRodData(
                      toY: income,

                      width: isMobile ? 35 : 45,

                      color: Colors.green,

                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),

                BarChartGroupData(
                  x: 1,

                  barRods: [
                    BarChartRodData(
                      toY: expense,

                      width: isMobile ? 35 : 45,

                      color: Colors.red,

                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ],

              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    reservedSize: 35,

                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Income',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );

                        case 1:
                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Expense',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );

                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    reservedSize: 55,

                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),

                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
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
        ),
      ],
    );
  }

  Widget _buildCategoryChart(
    Map<String, double> categoryExpenses,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending by Category',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,

          height: isMobile ? 330 : 360,

          padding: EdgeInsets.all(isMobile ? 12 : 20),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: categoryExpenses.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.pie_chart_outline,
                        size: 50,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 12),

                      Text(
                        'No expense data available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : PieChart(
                  PieChartData(
                    sectionsSpace: 3,

                    centerSpaceRadius: isMobile ? 35 : 45,

                    sections: categoryExpenses.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value,

                        title: entry.key,

                        radius: isMobile ? 85 : 100,

                        color: _getCategoryColor(entry.key),

                        titleStyle: TextStyle(
                          fontSize: isMobile ? 10 : 12,

                          fontWeight: FontWeight.bold,

                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
