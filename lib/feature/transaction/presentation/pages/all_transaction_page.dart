import 'dart:ui';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';

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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  void _showReceipt(String url) {
    final isPdf = url.toLowerCase().contains('.pdf');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 700,
                height: 600,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.16)
                        : Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Receipt Preview',
                            style: TextStyle(
                              color: isDark ? Colors.white : TransactionWidgetPalette.ink,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: isDark ? Colors.white70 : null,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: isPdf
                          ? SfPdfViewer.network(url)
                          : Image.network(url, fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

    return RefreshIndicator(
      color: TransactionWidgetPalette.teal,
      onRefresh: () async {
        context.read<TransactionBloc>().add(GetAllTransaction());
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LiquidGlassBackground(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Stack(
                  children: [
                    const TransactionTopBackground(height: 245, bottomRadius: 40),
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
                            onBack: () {
                              context.pop();
                            },
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
                                    final transaction =
                                        state.transactions[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: TransactionTile(
                                        description: transaction.description,
                                        amount: transaction.amount,
                                        isMobile: isMobile,
                                        receiptUrl: transaction.receiptUrl,

                                        onReceiptTap: () {
                                          _showReceipt(transaction.receiptUrl!);
                                        },
                                        onTap: () async {
                                          final result = await context.push(
                                            RoutesName.updateTransactionpage,
                                            extra: transaction,
                                          );

                                          if (result == true &&
                                              context.mounted) {
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
        ),
      ),
    ),
  );
  }
}
