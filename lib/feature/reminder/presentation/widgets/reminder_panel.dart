import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_card.dart';
import 'package:expense_tracker/feature/profile/presentation/widget/app_colors.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_option_tile.dart';
import 'package:flutter/material.dart';

class ReminderPanel extends StatelessWidget {
  final bool dailyEnabled;
  final TimeOfDay selectedTime;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTimeTap;
  final VoidCallback onSave;

  const ReminderPanel({
    super.key,
    required this.dailyEnabled,
    required this.selectedTime,
    required this.onToggle,
    required this.onTimeTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedTime = selectedTime.format(context);

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF134E4A), const Color(0xFF0F766E)]
                    : const [Color(0xFFE6F7F5), Color(0xFFCCFBF1)],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.alarm_rounded,
              color: AppColors.teal,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Daily Reminder',
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            dailyEnabled ? 'Reminder is enabled' : 'Reminder is disabled',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : AppColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 26),

          ReminderOptionTile(
            icon: Icons.notifications_active_rounded,
            title: 'Daily Notifications',
            subtitle: dailyEnabled ? 'Active every day' : 'Currently turned off',
            trailing: Switch(
              value: dailyEnabled,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.teal,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.border,
              onChanged: onToggle,
            ),
          ),

          const SizedBox(height: 12),

          ReminderOptionTile(
            icon: Icons.access_time_rounded,
            title: 'Reminder Time',
            subtitle: formattedTime,
            enabled: dailyEnabled,
            onTap: onTimeTap,
            trailing: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: dailyEnabled ? AppColors.teal : AppColors.muted,
            ),
          ),

          const SizedBox(height: 28),

          LiquidGlassButton(
            onPressed: onSave,
            label: 'Save Reminder',
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}
