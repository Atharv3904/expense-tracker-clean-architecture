import 'package:expense_tracker/core/auth/supabase_auth_fp_listener.dart';
import 'package:expense_tracker/core/config/app_config.dart';
import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/notification/notification_service.dart';
import 'package:expense_tracker/core/router/app_router.dart';
import 'package:expense_tracker/core/widgets/app_error_widget.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initializationError;

  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );
  } catch (error) {
    initializationError = 'Unable to connect to the server. Please try again.';
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    initializationError ??=
        'Some services are currently unavailable. Please try again.';
  }

  try {
    await init();
  } catch (error) {
    initializationError ??=
        'The application could not be initialized. Please try again.';
  }

  try {
    SupabaseAuthFpListener.initialize(AppRouter.router);
  } catch (error) {
    initializationError ??=
        'Authentication could not be initialized. Please try again.';
  }

  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
  } catch (error) {
    initializationError ??=
        'Notifications could not be initialized. Please try again.';
  }

  runApp(MyApp(initializationError: initializationError));
}

class MyApp extends StatelessWidget {
  final String? initializationError;

  const MyApp({super.key, this.initializationError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        if (initializationError != null) {
          return AppErrorWidget(message: initializationError!);
        }

        return FTheme(data: FTheme.neutral.light.touch, child: child!);
      },
    );
  }
}
