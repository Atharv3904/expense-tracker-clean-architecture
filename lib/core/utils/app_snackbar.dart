import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(BuildContext context, {required String message}) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 2)),
      );
  }
}
