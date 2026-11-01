import 'dart:ui';
import 'package:flutter/material.dart';

class ReceiptSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ReceiptSearchField({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  static const Color primary = Color(0xFF1B7A70);

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
                    : const Color(0xFF0F172A).withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Search receipts...',
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : const Color(0xFF64748B).withValues(alpha: 0.70),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 14, right: 10),
                child: const Icon(
                  Icons.search_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 46),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
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
