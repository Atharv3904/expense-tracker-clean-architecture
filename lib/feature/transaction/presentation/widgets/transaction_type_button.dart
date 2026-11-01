import 'package:flutter/material.dart';
import 'transaction_form_panel.dart';

class TransactionTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const TransactionTypeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedInk = isDark ? Colors.white70 : TransactionWidgetPalette.ink;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withValues(alpha: 0.85),
                ],
              )
            : LinearGradient(
                colors: isDark
                    ? const [
                        Color(0xFF1E293B),
                        Color(0xFF0F172A),
                      ]
                    : const [
                        Colors.white,
                        Color(0xFFF8FAFC),
                      ],
              ),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.8)
              : isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : const Color(0xFFE2E8F0),
          width: 1.3,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : TransactionWidgetPalette.ink.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? Colors.white : unselectedInk,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : unselectedInk,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
