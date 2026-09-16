import 'package:expense_tracker/feature/authentication/presentation/widgets/field_icon.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required String labelText,
  required String hintText,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,

    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 12, right: 10),
      child: FieldIcon(icon: icon),
    ),

    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

    suffixIcon: suffixIcon,

    filled: true,
    fillColor: Colors.white,

    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFFE8EEEB)),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFFE8EEEB)),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF2B8F84), width: 1.4),
    ),
  );
}
