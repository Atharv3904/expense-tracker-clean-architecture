import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginBottomLinks extends StatelessWidget {
  const LoginBottomLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTeal = isDark ? const Color(0xFF2DD4BF) : const Color(0xFF2B8F84);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(
          'New here?',
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF89918F),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(RoutesName.register);
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryTeal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Create account',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(RoutesName.forgotPage);
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryTeal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Forgot password?',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
