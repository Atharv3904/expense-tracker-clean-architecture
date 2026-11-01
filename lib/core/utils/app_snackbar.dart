import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(BuildContext context, {required String message}) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.92),
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
