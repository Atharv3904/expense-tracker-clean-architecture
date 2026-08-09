import 'package:expense_tracker/core/router/app_routes.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutesName.splashscreen,
    routes: AppRoutes.routes,
  );
}
