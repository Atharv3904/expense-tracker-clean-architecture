import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_empty_state.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_error_state.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_header.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_loading_list.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_search_field.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_top_background.dart';

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

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    return Scaffold(
      backgroundColor: TransactionWidgetPalette.bg,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Stack(
            children: [
              const TransactionTopBackground(height: 235, bottomRadius: 38),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        isMobile ? 16 : 24,
                        horizontalPadding,
                        0,
                      ),
                      child: TransactionHeader(
                        title: 'All Transactions',
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(height: isMobile ? 24 : 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: TransactionSearchField(
                        controller: searchController,
                        searchQuery: searchController.text,
                        onChanged: (value) {
                          setState(() {
                            context.read<TransactionBloc>().add(
                              GetAllTransaction(searchQuery: value),
                            );
                          });
                        },
                        onClear: () {
                          searchController.clear();

                          context.read<TransactionBloc>().add(
                            const GetAllTransaction(),
                          );

                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          if (state is TransactionLoading) {
                            return const TransactionLoadingList();
                          }

                          if (state is TransactionFailure) {
                            return TransactionErrorState(
                              message: state.message,
                            );
                          }

                          if (state is TransactionLoaded) {
                            if (state.transactions.isEmpty) {
                              return const TransactionEmptyState();
                            }

                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(
                                horizontalPadding,
                                0,
                                horizontalPadding,
                                24,
                              ),
                              itemCount: state.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = state.transactions[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TransactionTile(
                                    description: transaction.description,
                                    amount: transaction.amount,
                                    isMobile: isMobile,
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
            ],
          ),
        ),
      ),
    );
  }
}
