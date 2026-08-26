// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  final Color? iconColor;
  final Color? titleColor;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return Material(
      color: Colors.white,

      borderRadius: BorderRadius.circular(16),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(16),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),

          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,

                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.10),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: effectiveIconColor, size: 22),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(Icons.chevron_right_rounded, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}
