import 'dart:async';

import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthFpListener {
  SupabaseAuthFpListener._();

  static StreamSubscription<AuthState>? _subscription;

  static void initialize(GoRouter router) {
    _subscription?.cancel();

    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      authState,
    ) {
      if (authState.event == AuthChangeEvent.passwordRecovery) {
        router.go(RoutesName.resetPassword);
      }
    });
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
