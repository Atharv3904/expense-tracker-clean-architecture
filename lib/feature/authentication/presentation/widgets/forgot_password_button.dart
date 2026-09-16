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
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: teal.withValues(alpha: 0.52),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Send Reset Link',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
      ),
    );
  }
}
