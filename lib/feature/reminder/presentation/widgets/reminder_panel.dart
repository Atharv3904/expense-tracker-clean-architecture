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
    final formattedTime = selectedTime.format(context);

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.softMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.alarm_rounded,
              color: AppColors.teal,
              size: 36,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Daily Reminder',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            dailyEnabled ? 'Reminder is enabled' : 'Reminder is disabled',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          ReminderOptionTile(
            icon: Icons.notifications_active_rounded,
            title: 'Daily notifications',
            subtitle: dailyEnabled
                ? 'Active every day'
                : 'Currently turned off',
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

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Save Reminder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
