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

  static const Color primary = Color(0xFF238E84);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search receipts...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3A3),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: primary,
            size: 29,
          ),

          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                ),

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(vertical: 19),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
