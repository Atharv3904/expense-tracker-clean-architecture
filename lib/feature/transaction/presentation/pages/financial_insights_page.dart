import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_categories_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_types_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

    context.read<TransactionBloc>().add(const GetAllTransaction());

    loadTransactionTypes();
    loadCategories();
  }

  Future<void> loadTransactionTypes() async {
    final usecase = sl<TransactionTypesUsecase>();

    final types = await usecase();

    final income = types.firstWhere((type) => type.type == 'income');

    final expense = types.firstWhere((type) => type.type == 'expense');

    if (!mounted) return;

    setState(() {
      incomeTypeId = income.id;
      expenseTypeId = expense.id;
    });
  }

  Future<void> loadCategories() async {
    final usecase = sl<TransactionCategoriesUsecase>();

    final result = await usecase();

    if (!mounted) return;

    setState(() {
      categories = result;
    });
  }

  Map<String, double> _calculateCategoryExpenses(List transactions) {
    final Map<String, double> categoryExpenses = {};

    for (final transaction in transactions) {
      // Only expenses
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

      // Category not found
      if (category == null) {
        continue;
      }

      categoryExpenses[category.name] =
          (categoryExpenses[category.name] ?? 0) + transaction.amount;
    }

    return categoryExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Insights')),

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

            return _buildChart(income, expense, categoryExpenses);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildChart(
    double income,
    double expense,
    Map<String, double> categoryExpenses,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // -------------------------
          // INCOME VS EXPENSE
          // -------------------------
          const Text(
            'Income vs Expense',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,

                maxY: (income > expense ? income : expense) + 20000,

                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: income, width: 45)],
                  ),

                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: expense, width: 35)],
                  ),
                ],

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Income');

                          case 1:
                            return const Text('Expense');

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
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 12),
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

          const SizedBox(height: 40),

          // -------------------------
          // SPENDING BY CATEGORY
          // -------------------------
          const Text(
            'Spending by Category',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: categoryExpenses.isEmpty
                ? const Center(child: Text('No expense data available'))
                : PieChart(
                    PieChartData(
                      sections: categoryExpenses.entries.map((entry) {
                        return PieChartSectionData(
                          value: entry.value,
                          title: entry.key,
                          radius: 100,

                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
