import 'package:expense_tracker/core/router/app_routes.dart';
import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutesName.splashscreen,

    redirect: (context, state) {
      final uri = state.uri;

      if (uri.scheme == 'spendly' && uri.host == 'reset-password') {
        return RoutesName.resetPassword;
      }

      return null;
    },

    routes: AppRoutes.routes,
  );
}
