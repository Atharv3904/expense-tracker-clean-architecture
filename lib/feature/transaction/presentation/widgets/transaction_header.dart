import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionHeader extends StatelessWidget {
  final String title;
  final bool isMobile;
  final VoidCallback? onBack;
  final Widget? trailing;

  const TransactionHeader({
    super.key,
    required this.title,
    required this.isMobile,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBack ?? () => context.pop(),
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 14),
          trailing!,
        ] else
          const SizedBox(width: 42),
      ],
    );
  }
}
