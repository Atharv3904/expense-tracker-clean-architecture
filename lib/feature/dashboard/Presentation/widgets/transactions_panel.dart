import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/empty_transaction.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/transaction_card.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/transaction_error.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransactionsPanel extends StatelessWidget {
  final bool isMobile;

  const TransactionsPanel({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Transactions History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: DashboardPalettes.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: DashboardPalettes.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
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
                child: const Text('See all'),
              ),
            ],
          ),
        ),

        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransactionLoaded) {
              if (state.transactions.isEmpty) {
                return const EmptyTransactions();
              }

              final items = state.transactions.take(3).toList();

              return Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    TransactionCard(
                      description: items[i].description,
                      amount: items[i].amount,
                      onTap: () async {
                        final result = await context.push(
                          RoutesName.updateTransactionpage,
                          extra: items[i],
                        );

                        if (result == true && context.mounted) {
                          context.read<TransactionBloc>().add(
                            const LoadTransaction(),
                          );
                        }
                      },
                    ),
                    if (i != items.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            }

            if (state is TransactionFailure) {
              return TransactionError(message: state.message);
            }

            return const EmptyTransactions();
          },
        ),
      ],
    );
  }
}
