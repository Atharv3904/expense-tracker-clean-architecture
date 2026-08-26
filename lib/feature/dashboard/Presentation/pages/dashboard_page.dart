import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_states.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/balance_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/empty_transaction.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/summary_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/transaction_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/transaction_error.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _getGrettings() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,

        title: Text(
          'Expense Tracker',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: BlocBuilder<DashboardCubit, DashboardStates>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DashboardLoaded) {
            final summary = state.summary;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = Responsive.isMobile(context);
                final isTablet = Responsive.isTablet(context);
                final isDesktop = Responsive.isDesktop(context);

                final horizontalPadding = isMobile
                    ? 16.0
                    : isTablet
                    ? 28.0
                    : 32.0;

                final maxContentWidth = isDesktop ? 1400.0 : double.infinity;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isMobile ? 20 : 28,
                  ),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGrettings()} 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: isMobile ? 24 : 28,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Here's your financial summary",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 24),
                          BalanceCard(
                            balance: summary.balance,
                            isMobile: isMobile,
                          ),

                          const SizedBox(height: 16),

                          if (isMobile)
                            Column(
                              children: [
                                SummaryCard(
                                  title: 'Income',
                                  amount: summary.totalIncome,
                                  icon: Icons.arrow_downward_rounded,
                                  color: Colors.green,
                                ),

                                const SizedBox(height: 12),

                                SummaryCard(
                                  title: 'Expense',
                                  amount: summary.totalExpense,
                                  icon: Icons.arrow_upward_rounded,
                                  color: Colors.redAccent,
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: SummaryCard(
                                    title: 'Income',
                                    amount: summary.totalIncome,
                                    icon: Icons.arrow_downward_rounded,
                                    color: Colors.green,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: SummaryCard(
                                    title: 'Expense',
                                    amount: summary.totalExpense,
                                    icon: Icons.arrow_upward_rounded,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              TextButton(
                                onPressed: () async {
                                  final result = await context.push(
                                    RoutesName.allTransactionpage,
                                  );

                                  if (result == true && context.mounted) {
                                    context.read<TransactionBloc>().add(
                                      const LoadTransaction(),
                                    );
                                  }
                                },
                                child: const Text('See All'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          BlocBuilder<TransactionBloc, TransactionState>(
                            builder: (context, transactionState) {
                              if (transactionState is TransactionLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (transactionState is TransactionLoaded) {
                                if (transactionState.transactions.isEmpty) {
                                  return const EmptyTransactions();
                                }

                                return Column(
                                  children: [
                                    ...transactionState.transactions.take(3).map(
                                      (transaction) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: TransactionCard(
                                            description:
                                                transaction.description,
                                            amount: transaction.amount,
                                            onTap: () async {
                                              final result = await context.push(
                                                RoutesName
                                                    .updateTransactionpage,
                                                extra: transaction,
                                              );

                                              if (result == true &&
                                                  context.mounted) {
                                                context
                                                    .read<TransactionBloc>()
                                                    .add(
                                                      const LoadTransaction(),
                                                    );
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }

                              if (transactionState is TransactionFailure) {
                                return TransactionError(
                                  message: transactionState.message,
                                );
                              }

                              return const EmptyTransactions();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
