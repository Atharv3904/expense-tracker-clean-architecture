import 'package:flutter/material.dart';

import 'app_field_icon.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  static const teal = Color(0xFF2B8F84);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: ink, fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: muted.withValues(alpha: 0.78),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 10),
          child: AppFieldIcon(icon: icon),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: teal, width: 1.4),
        ),
      ),
    );
  }
}
