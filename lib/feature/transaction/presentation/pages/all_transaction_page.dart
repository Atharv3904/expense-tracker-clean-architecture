import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AllTransactionPage extends StatefulWidget {
  const AllTransactionPage({super.key});

  @override
  State<AllTransactionPage> createState() => _AllTransactionPageState();
}

class _AllTransactionPageState extends State<AllTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        leading: IconButton(
          onPressed: () {
            context.pop(true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No transactions yet'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];

                return Card(
                  child: ListTile(
                    title: Text(transaction.description),
                    subtitle: Text('₹${transaction.amount}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final result = await context.push(
                        RoutesName.updateTransactionpage,
                        extra: transaction,
                      );

                      if (result == true && context.mounted) {
                        context.read<TransactionBloc>().add(
                          const GetAllTransaction(),
                        );
                      }
                    },
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
