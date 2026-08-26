import 'package:expense_tracker/core/responsive/responsive.dart';
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
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 800.0
        : 1000.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 16 : 24,
                  16,
                  isMobile ? 16 : 24,
                  12,
                ),
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
                        return const Center(
                          child: Text('No transactions found'),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 16 : 24,
                          8,
                          isMobile ? 16 : 24,
                          20,
                        ),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),

                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 14 : 18,
                                vertical: isMobile ? 6 : 8,
                              ),

                              // Transaction icon
                              leading: Container(
                                width: isMobile ? 42 : 46,
                                height: isMobile ? 42 : 46,

                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: Colors.green,
                                ),
                              ),

                              // Description + amount
                              title: Text(
                                transaction.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),

                                child: Text(
                                  'Transaction amount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),

                              // Amount + arrow
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₹${transaction.amount}',

                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
