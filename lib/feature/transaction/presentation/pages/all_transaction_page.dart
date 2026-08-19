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
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Transaction list
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransactionFailure) {
                  return Center(child: Text(state.message));
                }

                if (state is TransactionLoaded) {
                  final filteredTransactions = state.transactions.where((
                    transaction,
                  ) {
                    return transaction.description.toLowerCase().contains(
                      searchQuery,
                    );
                  }).toList();

                  if (filteredTransactions.isEmpty) {
                    return const Center(child: Text('No transactions found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];

                      return Card(
                        child: ListTile(
                          title: Text(transaction.description),
                          subtitle: Text('₹${transaction.amount}'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
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
          ),
        ],
      ),
    );
  }
}
