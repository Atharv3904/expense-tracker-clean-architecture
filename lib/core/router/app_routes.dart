import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/logout_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/forgot_pass_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/login_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/register_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/splash_page.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/pages/dashboard_page.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/pages/change_password_page.dart';
import 'package:expense_tracker/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:expense_tracker/feature/profile/presentation/pages/profile_page.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/all_transaction_page.dart';
import 'package:expense_tracker/feature/transaction/presentation/pages/financial_insights_page.dart';
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

    // DASHBOARD
    GoRoute(
      path: RoutesName.dashboard,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<DashboardCubit>()..dashboardSummary()),
          BlocProvider(
            create: (_) => sl<TransactionBloc>()..add(const LoadTransaction()),
          ),
        ],
        child: const DashboardPage(),
      ),
    ),

    GoRoute(
      path: RoutesName.forgotPage,
      builder: (context, state) => const ForgotPassPage(),
    ),

    GoRoute(
      path: RoutesName.logout,
      builder: (context, state) => const LogoutPage(),
    ),

    // ADD TRANSACTION
    GoRoute(
      path: RoutesName.addTransactionpage,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<TransactionBloc>(),
        child: const AddTransactionPage(),
      ),
    ),

    // UPDATE TRANSACTION
    GoRoute(
      path: RoutesName.updateTransactionpage,
      builder: (context, state) {
        final transaction = state.extra as TransactionEntity;

        return BlocProvider(
          create: (_) => sl<TransactionBloc>(),
          child: UpdateTransactionPage(transaction: transaction),
        );
      },
    ),

    // FINANCIAL INSIGHTS
    GoRoute(
      path: RoutesName.financialInsights,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<TransactionBloc>(),
        child: const FinancialInsightsPage(),
      ),
    ),

    // ALL TRANSACTIONS
    GoRoute(
      path: RoutesName.allTransactionpage,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<TransactionBloc>()..add(GetAllTransaction()),
        child: const AllTransactionPage(),
      ),
    ),

    GoRoute(
      path: RoutesName.profilePage,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
        child: const ProfilePage(),
      ),
    ),

    GoRoute(
      path: RoutesName.editProfile,
      builder: (context, state) {
        final name = state.extra as String;

        return BlocProvider(
          create: (_) => sl<ProfileBloc>(),
          child: EditProfilePage(currentName: name),
        );
      },
    ),

    GoRoute(
      path: RoutesName.changePassword,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProfileBloc>(),
        child: const ChangePasswordPage(),
      ),
    ),
  ];
}
