import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _AllTransactionPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const softMint = Color(0xFFEAF8F5);
  static const income = Color(0xFF22B573);
}

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

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    return Scaffold(
      backgroundColor: _AllTransactionPalette.bg,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Stack(
            children: [
              const _AllTransactionTopBackground(),
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
                      child: _AllTransactionHeader(isMobile: isMobile),
                    ),
                    SizedBox(height: isMobile ? 24 : 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: _SearchField(
                        controller: searchController,
                        searchQuery: searchQuery,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        onClear: () {
                          searchController.clear();

                          setState(() {
                            searchQuery = '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          if (state is TransactionLoading) {
                            return const _TransactionListSkeleton();
                          }

                          if (state is TransactionFailure) {
                            return _ErrorState(message: state.message);
                          }

                          if (state is TransactionLoaded) {
                            final filteredTransactions = state.transactions
                                .where((transaction) {
                                  return transaction.description
                                      .toLowerCase()
                                      .contains(searchQuery);
                                })
                                .toList();

                            if (filteredTransactions.isEmpty) {
                              return const _EmptySearchState();
                            }

                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(
                                horizontalPadding,
                                0,
                                horizontalPadding,
                                24,
                              ),
                              itemCount: filteredTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction = filteredTransactions[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _TransactionTile(
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

class _AllTransactionTopBackground extends StatelessWidget {
  const _AllTransactionTopBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _AllTransactionPalette.teal,
            _AllTransactionPalette.tealDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -42, left: -34, child: _HeaderRing(size: 132)),
          Positioned(top: 42, right: -38, child: _HeaderRing(size: 126)),
          Positioned(top: 86, left: 90, child: _HeaderRing(size: 64)),
        ],
      ),
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;

  const _HeaderRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}

class _AllTransactionHeader extends StatelessWidget {
  final bool isMobile;

  const _AllTransactionHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              context.pop();
            },
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'All Transactions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _AllTransactionPalette.ink.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: _AllTransactionPalette.ink,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: TextStyle(
            color: _AllTransactionPalette.muted.withValues(alpha: 0.76),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _AllTransactionPalette.teal,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: _AllTransactionPalette.muted,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String description;
  final dynamic amount;
  final bool isMobile;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.description,
    required this.amount,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 18,
            vertical: isMobile ? 13 : 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _AllTransactionPalette.border),
            boxShadow: [
              BoxShadow(
                color: _AllTransactionPalette.ink.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isMobile ? 48 : 52,
                height: isMobile ? 48 : 52,
                decoration: const BoxDecoration(
                  color: _AllTransactionPalette.softMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: _AllTransactionPalette.teal,
                  size: 21,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _AllTransactionPalette.ink,
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Transaction amount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _AllTransactionPalette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '₹$amount',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w900,
                  color: _AllTransactionPalette.income,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: _AllTransactionPalette.muted,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(18),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _AllTransactionPalette.border),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: _AllTransactionPalette.teal,
              size: 42,
            ),
            SizedBox(height: 12),
            Text(
              'No transactions found',
              style: TextStyle(
                color: _AllTransactionPalette.ink,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(18),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _AllTransactionPalette.border),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _AllTransactionPalette.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TransactionListSkeleton extends StatelessWidget {
  const _TransactionListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          height: 78,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _AllTransactionPalette.border,
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
