import 'dart:ui';
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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TransactionsPanel extends StatelessWidget {
  final bool isMobile;

  const TransactionsPanel({super.key, required this.isMobile});

  void _showReceipt(BuildContext context, String url) {
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
                              color: isDark ? Colors.white : DashboardPalettes.ink,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: DashboardPalettes.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: isDark ? Colors.white : DashboardPalettes.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final result = await context.push(
                    RoutesName.allTransactionpage,
                  );

                  if (result == true && context.mounted) {
                    context.read<TransactionBloc>().add(
                      const LoadTransaction(),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardPalettes.teal.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: DashboardPalettes.tealLight.withValues(alpha: 0.28),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF2DD4BF)
                              : DashboardPalettes.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: isDark
                            ? const Color(0xFF2DD4BF)
                            : DashboardPalettes.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: DashboardPalettes.teal,
                  ),
                ),
              );
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
                      receiptUrl: items[i].receiptUrl,
                      onReceiptTap: () {
                        _showReceipt(context, items[i].receiptUrl!);
                      },
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
