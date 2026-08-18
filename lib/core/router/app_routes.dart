import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/logout_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/forgot_pass_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/login_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/register_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/splash_page.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/pages/dashboard_page.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/all_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/update_transaction_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static final List<GoRoute> routes = [
    GoRoute(
      path: RoutesName.splashscreen,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RoutesName.register,
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: RoutesName.login,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: RoutesName.dashboard,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<DashboardCubit>()..dashboardSummary()),
          BlocProvider(
            create: (_) => sl<TransactionBloc>()..add(LoadTransaction()),
          ),
        ],
        child: DashboardPage(),
      ),
    ),

    GoRoute(
      path: RoutesName.forgotPage,
      builder: (context, state) => ForgotPassPage(),
    ),

    GoRoute(path: RoutesName.logout, builder: (context, state) => LogoutPage()),
    GoRoute(
      path: RoutesName.addTransactionpage,
      builder: (context, state) => AddTransactionPage(),
    ),

    GoRoute(
      path: RoutesName.updateTransactionpage,
      builder: (context, state) {
        final transaction = state.extra as TransactionEntity;
        return BlocProvider(
          create: (context) => sl<TransactionBloc>(),
          child: UpdateTransactionPage(transaction: transaction),
        );
      },
    ),

    GoRoute(
      path: RoutesName.allTransactionpage,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(const GetAllTransaction()),
          child: const AllTransactionPage(),
        );
      },
    ),
  ];
}
