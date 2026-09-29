import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';

import 'package:expense_tracker/feature/transaction/domain/entities/today_income_expense_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_states.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_states.dart';

import 'package:expense_tracker/feature/transaction/presentation/widgets/overview_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/responsive_chart.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_header.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_top_background.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialInsightsPage extends StatefulWidget {
  final VoidCallback onBack;

  const FinancialInsightsPage({super.key, required this.onBack});

  @override
  State<FinancialInsightsPage> createState() => _FinancialInsightsPageState();
}

class _FinancialInsightsPageState extends State<FinancialInsightsPage> {
  String? incomeTypeId;
  String? expenseTypeId;

  List<TransactionCategoryEntity> categories = [];

  List<TodayIncomeExpenseEntity> todayIncomeExpense = [];

  List<TodayIncomeExpenseEntity> _calculateTodayIncomeExpense(
    List transactions,
  ) {
    final now = DateTime.now();

    // Start of today: 28 Sep 00:00
    final startOfToday = DateTime(now.year, now.month, now.day);

    // Start of tomorrow: 29 Sep 00:00
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    debugPrint('========== TODAY CHART ==========');
    debugPrint('Now: $now');
    debugPrint('Start of today: $startOfToday');
    debugPrint('Start of tomorrow: $startOfTomorrow');
    debugPrint('Total transactions: ${transactions.length}');

    final todayTransactions = transactions.where((transaction) {
      // Supabase created_at can be UTC.
      // Convert it to device local time.
      final date = transaction.date.toLocal();

      final isToday =
          !date.isBefore(startOfToday) && date.isBefore(startOfTomorrow);

      debugPrint(
        'Transaction: $date | '
        'Amount: ${transaction.amount} | '
        'Is today: $isToday',
      );

      return isToday;
    }).toList();

    debugPrint('Today transactions found: ${todayTransactions.length}');

    // Oldest → newest
    todayTransactions.sort((a, b) => a.date.compareTo(b.date));

    double cumulativeIncome = 0;
    double cumulativeExpense = 0;

    final result = <TodayIncomeExpenseEntity>[];

    for (final transaction in todayTransactions) {
      if (transaction.typeId == incomeTypeId) {
        cumulativeIncome += transaction.amount;
      }

      if (transaction.typeId == expenseTypeId) {
        cumulativeExpense += transaction.amount;
      }

      result.add(
        TodayIncomeExpenseEntity(
          time: transaction.date.toLocal(),
          income: cumulativeIncome,
          expense: cumulativeExpense,
        ),
      );
    }

    debugPrint('Chart points created: ${result.length}');

    debugPrint('=================================');

    return result;
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
        // --------------------------------------------------------
        // TYPE LISTENER
        // --------------------------------------------------------
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
              AppSnackbar.show(context, message: state.message);
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
              AppSnackbar.show(context, message: state.message);
            }
          },
        ),
      ],

      child: Scaffold(
        backgroundColor: TransactionWidgetPalette.bg,

        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            double income = 0;
            double expense = 0;

            Map<String, double> categoryExpenses = {};

            if (state is TransactionLoaded) {
              for (final transaction in state.transactions) {
                if (transaction.typeId == incomeTypeId) {
                  income += transaction.amount;
                }

                if (transaction.typeId == expenseTypeId) {
                  expense += transaction.amount;
                }
              }

              categoryExpenses = _calculateCategoryExpenses(state.transactions);

              todayIncomeExpense = _calculateTodayIncomeExpense(
                state.transactions,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Reload ALL transactions.
                context.read<TransactionBloc>().add(const GetAllTransaction());

                // Reload transaction types.
                context.read<TypeBloc>().add(const GetTypesTransaction());

                // Reload categories.
                context.read<CategoryBloc>().add(
                  const GetCategoryTransaction(),
                );
              },

              child: SingleChildScrollView(
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
                                  onBack: widget.onBack,
                                ),

                                SizedBox(height: isMobile ? 26 : 32),

                                OverviewPanel(
                                  income: income,
                                  expense: expense,
                                  isMobile: isMobile,
                                ),

                                const SizedBox(height: 24),

                                ResponsiveCharts(
                                  income: income,
                                  expense: expense,
                                  categoryExpenses: categoryExpenses,

                                  dailyIncomeExpense: todayIncomeExpense,

                                  isMobile: isMobile,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
