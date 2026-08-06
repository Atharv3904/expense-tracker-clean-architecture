import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://psyhsojqxskjipgdqnnh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzeWhzb2pxeHNramlwZ2Rxbm5oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU4NDE2NjEsImV4cCI6MjEwMTQxNzY2MX0.0an7ulZf1oQO-WjXZSLDaMDfyBxCNHrQGoG7vi7dJB8',
  );
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
