import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..dashboardSummary(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),

        appBar: AppBar(
          title: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
                size: 30,
              ),

              const SizedBox(width: 10),

              const Text("Expense Tracker"),
            ],
          ),

          actions: [
            IconButton(
              onPressed: () {
                context.push(RoutesName.logout);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),

        body: BlocBuilder<DashboardCubit, DashboardStates>(
          builder: (context, state) {
            // Loading
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Failure
            if (state is DashboardFailure) {
              return Center(child: Text(state.message));
            }

            // Success
            if (state is DashboardLoaded) {
              final summary = state.summary;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Good morning 👋",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Here's your financial summary",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 25),

                    // Balance
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Balance",
                            style: TextStyle(color: Colors.white70),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "₹${summary.balance.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Income & Expense
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Income",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "₹${summary.totalIncome.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Expense",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "₹${summary.totalExpense.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      color: Colors.white,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 40,
                            color: Colors.grey,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "No transactions yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
