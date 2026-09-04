import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_event.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ReminderPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const softMint = Color(0xFFEAF8F5);
}

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  bool dailyEnabled = false;

  TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();

    context.read<ReminderBloc>().add(const LoadReminder());
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: _ReminderPalette.softMint,
              hourMinuteTextColor: _ReminderPalette.ink,
              dialHandColor: _ReminderPalette.teal,
              dialBackgroundColor: _ReminderPalette.softMint,
              entryModeIconColor: _ReminderPalette.teal,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _ReminderPalette.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    setState(() {
      selectedTime = time;
    });
  }

  void saveReminder() {
    final reminder = ReminderEntity(
      dailyEnabled: dailyEnabled,
      hour: selectedTime.hour,
      minute: selectedTime.minute,
    );

    if (dailyEnabled) {
      context.read<ReminderBloc>().add(ScheduleReminder(reminder));
    } else {
      context.read<ReminderBloc>().add(const CancelReminder());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (state is ReminderLoaded) {
          setState(() {
            dailyEnabled = state.reminder.dailyEnabled;

            selectedTime = TimeOfDay(
              hour: state.reminder.hour,
              minute: state.reminder.minute,
            );
          });
        }

        if (state is ReminderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder added successfully')),
          );
        }

        if (state is ReminderFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is ReminderCancel) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Reminder cancelled')));
        }
      },
      child: Scaffold(
        backgroundColor: _ReminderPalette.bg,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              const _ReminderTopBackground(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                  child: Column(
                    children: [
                      const _ReminderHeader(),
                      const SizedBox(height: 28),
                      _ReminderPanel(
                        dailyEnabled: dailyEnabled,
                        selectedTime: selectedTime,
                        onToggle: (value) {
                          setState(() {
                            dailyEnabled = value;
                          });
                        },
                        onTimeTap: dailyEnabled ? selectTime : null,
                        onSave: saveReminder,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderTopBackground extends StatelessWidget {
  const _ReminderTopBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_ReminderPalette.teal, _ReminderPalette.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -42, left: -34, child: _HeaderRing(size: 132)),
          Positioned(top: 42, right: -38, child: _HeaderRing(size: 126)),
          Positioned(top: 86, left: 90, child: _HeaderRing(size: 64)),
        ],
      ),
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;

  const _HeaderRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}

class _ReminderHeader extends StatelessWidget {
  const _ReminderHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Reminders',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderPanel extends StatelessWidget {
  final bool dailyEnabled;
  final TimeOfDay selectedTime;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTimeTap;
  final VoidCallback onSave;

  const _ReminderPanel({
    required this.dailyEnabled,
    required this.selectedTime,
    required this.onToggle,
    required this.onTimeTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = selectedTime.format(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: _ReminderPalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: _ReminderPalette.softMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.alarm_rounded,
              color: _ReminderPalette.teal,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Daily Reminder',
            style: TextStyle(
              color: _ReminderPalette.ink,
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
              color: _ReminderPalette.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          _ReminderOptionTile(
            icon: Icons.notifications_active_rounded,
            title: 'Daily notifications',
            subtitle: dailyEnabled
                ? 'Active every day'
                : 'Currently turned off',
            trailing: Switch(
              value: dailyEnabled,
              activeThumbColor: Colors.white,
              activeTrackColor: _ReminderPalette.teal,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: _ReminderPalette.border,
              onChanged: onToggle,
            ),
          ),
          const SizedBox(height: 12),
          _ReminderOptionTile(
            icon: Icons.access_time_rounded,
            title: 'Reminder Time',
            subtitle: formattedTime,
            enabled: dailyEnabled,
            onTap: onTimeTap,
            trailing: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: dailyEnabled
                  ? _ReminderPalette.teal
                  : _ReminderPalette.muted,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ReminderPalette.teal,
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

class _ReminderOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool enabled;
  final VoidCallback? onTap;

  const _ReminderOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled
        ? _ReminderPalette.teal
        : _ReminderPalette.muted;

    return Material(
      color: enabled ? Colors.white : const Color(0xFFF7F9F8),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _ReminderPalette.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(
                    alpha: enabled ? 0.11 : 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: effectiveColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Opacity(
                  opacity: enabled ? 1 : 0.62,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _ReminderPalette.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _ReminderPalette.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
