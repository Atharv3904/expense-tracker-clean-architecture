import 'package:flutter/material.dart';

class AppSectionLabel extends StatelessWidget {
  final String text;

  const AppSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF07091D),
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    );
  }
}
