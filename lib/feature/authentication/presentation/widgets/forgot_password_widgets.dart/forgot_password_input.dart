import 'package:flutter/material.dart';

class ForgotPasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final Color ink;
  final Color muted;
  final Color border;
  final Color teal;

  const ForgotPasswordInput({
    super.key,
    required this.controller,
    required this.ink,
    required this.muted,
    required this.border,
    required this.teal,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: ink, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',

        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),

        hintStyle: TextStyle(
          color: muted.withValues(alpha: 0.75),
          fontWeight: FontWeight.w500,
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 10),
          child: _FieldIcon(icon: Icons.email_outlined, teal: teal),
        ),

        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: teal, width: 1.4),
        ),
      ),
    );
  }
}

class _FieldIcon extends StatelessWidget {
  final IconData icon;
  final Color teal;

  const _FieldIcon({required this.icon, required this.teal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: teal.withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: teal, size: 18),
    );
  }
}
