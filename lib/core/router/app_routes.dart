import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/logout_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/forgot_pass_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/login_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/register_page.dart';
import 'package:expense_tracker/feature/authentication/presentation/pages/splash_page.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/pages/dashboard_page.dart';
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
      builder: (context, state) => DashboardPage(),
    ),
    GoRoute(
      path: RoutesName.forgotPage,
      builder: (context, state) => ForgotPassPage(),
    ),
    GoRoute(path: RoutesName.logout, builder: (context, state) => LogoutPage()),
  ];
}
