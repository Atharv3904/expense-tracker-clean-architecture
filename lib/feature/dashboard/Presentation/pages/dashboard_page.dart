import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/presentation/cubit/dashboard_states.dart';

import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_Content.dart';

import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: DashboardPalettes.teal,
      onRefresh: () async {
        context.read<DashboardCubit>().dashboardSummary();
        context.read<TransactionBloc>().add(LoadTransaction());
        await Future<void>.value();
      },
      child: BlocListener<DashboardCubit, DashboardStates>(
        listener: (context, state) {
          if (state is DashboardFailure) {
            AppSnackbar.show(context, message: state.message);
          }
        },
        child: Scaffold(
          backgroundColor: DashboardPalettes.bg,
          body: BlocBuilder<DashboardCubit, DashboardStates>(
            builder: (context, state) {
              double balance = 0;
              double income = 0;
              double expense = 0;

              if (state is DashboardLoaded) {
                balance = state.summary.balance;
                income = state.summary.totalIncome;
                expense = state.summary.totalExpense;
              }

              return DashboardContent(
                balance: balance,
                income: income,
                expense: expense,
              );
            },
          ),
        ),
      ),
    );
  }
}
