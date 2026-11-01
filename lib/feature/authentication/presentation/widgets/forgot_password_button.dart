import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Color teal;

  const ForgotPasswordButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.teal,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassButton(
      isLoading: isLoading,
      onPressed: onPressed,
      label: 'Send Reset Link',
      icon: Icons.send_rounded,
    );
  }
}
