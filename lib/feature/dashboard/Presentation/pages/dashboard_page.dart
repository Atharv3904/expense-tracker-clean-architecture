// ignore_for_file: unused_field

import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_states.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/balance_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/empty_transaction.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/summary_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/transaction_card.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/widget/transaction_error.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _DashboardPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const income = Color(0xFF22B573);
  static const expense = Color(0xFFE8524A);
  static const softMint = Color(0xFFEAF8F5);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? name;
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().dashboardSummary();
  }

  String _getGrettings() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 21) return 'Good evening';
    return 'Good night';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _DashboardPalette.bg,
      body: BlocBuilder<DashboardCubit, DashboardStates>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const _DashboardSkeleton();
          }

          if (state is DashboardFailure) {
            return _DashboardErrorState(
              message: state.message,
              onRetry: () => context.read<DashboardCubit>().dashboardSummary(),
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
                    ? 18.0
                    : isTablet
                    ? 30.0
                    : 34.0;

                final maxContentWidth = isDesktop ? 1180.0 : double.infinity;

                return RefreshIndicator(
                  color: _DashboardPalette.teal,
                  onRefresh: () async {
                    context.read<DashboardCubit>().dashboardSummary();
                    context.read<TransactionBloc>().add(
                      const LoadTransaction(),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      children: [
                        const _DashboardTopBackground(),
                        SafeArea(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: maxContentWidth,
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  isMobile ? 18 : 24,
                                  horizontalPadding,
                                  24,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _DashboardHeader(
                                      greeting: _getGrettings(),
                                      isMobile: isMobile,
                                    ),
                                    SizedBox(height: isMobile ? 22 : 28),

                                    BalanceCard(
                                      balance: summary.balance,
                                      isMobile: isMobile,
                                    ),

                                    const SizedBox(height: 18),

                                    if (isMobile)
                                      Column(
                                        children: [
                                          SummaryCard(
                                            title: 'Income',
                                            amount: summary.totalIncome,
                                            icon: Icons.arrow_downward_rounded,
                                            color: _DashboardPalette.income,
                                          ),
                                          const SizedBox(height: 12),
                                          SummaryCard(
                                            title: 'Expense',
                                            amount: summary.totalExpense,
                                            icon: Icons.arrow_upward_rounded,
                                            color: _DashboardPalette.expense,
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
                                              icon:
                                                  Icons.arrow_downward_rounded,
                                              color: _DashboardPalette.income,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: SummaryCard(
                                              title: 'Expense',
                                              amount: summary.totalExpense,
                                              icon: Icons.arrow_upward_rounded,
                                              color: _DashboardPalette.expense,
                                            ),
                                          ),
                                        ],
                                      ),

                                    const SizedBox(height: 26),

                                    _TransactionsPanel(isMobile: isMobile),
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
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _DashboardTopBackground extends StatelessWidget {
  const _DashboardTopBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_DashboardPalette.teal, _DashboardPalette.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -42, left: -28, child: _HeaderBubble(size: 130)),
          Positioned(top: 42, right: -34, child: _HeaderBubble(size: 120)),
          Positioned(top: 84, left: 88, child: _HeaderBubble(size: 62)),
        ],
      ),
    );
  }
}

class _HeaderBubble extends StatelessWidget {
  final double size;

  const _HeaderBubble({required this.size});

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

class _DashboardHeader extends StatelessWidget {
  final String greeting;
  final bool isMobile;

  const _DashboardHeader({required this.greeting, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return Text(
                      ' 👋🏻 hii ${state.profile.name}... ${greeting}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 5),
              Text(
                'Expense Tracker',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: isMobile ? 24 : 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionsPanel extends StatelessWidget {
  final bool isMobile;

  const _TransactionsPanel({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _DashboardPalette.border),
        boxShadow: [
          BoxShadow(
            color: _DashboardPalette.ink.withValues(alpha: 0.055),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Transactions History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: _DashboardPalette.ink,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: _DashboardPalette.teal,
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
            builder: (context, transactionState) {
              if (transactionState is TransactionLoading) {
                return const _TransactionListSkeleton();
              }

              if (transactionState is TransactionLoaded) {
                if (transactionState.transactions.isEmpty) {
                  return const EmptyTransactions();
                }

                final items = transactionState.transactions.take(3).toList();

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

              if (transactionState is TransactionFailure) {
                return TransactionError(message: transactionState.message);
              }

              return const EmptyTransactions();
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget block({double height = 16, double? width, double radius = 18}) {
      return _Shimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: _DashboardPalette.border,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    return Stack(
      children: [
        const _DashboardTopBackground(),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              block(height: 16, width: 120),
              const SizedBox(height: 8),
              block(height: 30, width: 220),
              const SizedBox(height: 28),
              block(height: 156, radius: 30),
              const SizedBox(height: 18),
              block(height: 86, radius: 24),
              const SizedBox(height: 12),
              block(height: 86, radius: 24),
              const SizedBox(height: 26),
              block(height: 230, radius: 30),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionListSkeleton extends StatelessWidget {
  const _TransactionListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i == 2 ? 0 : 10),
          child: _Shimmer(
            child: Container(
              height: 74,
              decoration: BoxDecoration(
                color: _DashboardPalette.border,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Shimmer extends StatefulWidget {
  final Widget child;

  const _Shimmer({required this.child});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 - _controller.value * 2, 0),
              end: Alignment(1 - _controller.value * 2, 0),
              colors: const [
                Colors.transparent,
                Colors.white70,
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        const _DashboardTopBackground(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _DashboardPalette.border),
                boxShadow: [
                  BoxShadow(
                    color: _DashboardPalette.ink.withValues(alpha: 0.07),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: _DashboardPalette.expense.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 31,
                      color: _DashboardPalette.expense,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: _DashboardPalette.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _DashboardPalette.muted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: _DashboardPalette.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
