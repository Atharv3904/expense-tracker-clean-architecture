import 'dart:ui';
import 'package:flutter/material.dart';
import 'transaction_form_panel.dart';

class TransactionSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const TransactionSearchField({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : TransactionWidgetPalette.ink.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              color: isDark ? Colors.white : TransactionWidgetPalette.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : TransactionWidgetPalette.muted.withValues(alpha: 0.70),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 14, right: 10),
                child: const Icon(
                  Icons.search_rounded,
                  color: TransactionWidgetPalette.teal,
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 46),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white70 : TransactionWidgetPalette.muted,
                        size: 20,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
