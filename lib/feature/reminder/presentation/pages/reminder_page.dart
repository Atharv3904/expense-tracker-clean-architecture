import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_event.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_states.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_header.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_palette.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_panel.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_top_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              hourMinuteColor: ReminderPalette.softMint,
              hourMinuteTextColor: ReminderPalette.ink,
              dialHandColor: ReminderPalette.teal,
              dialBackgroundColor: ReminderPalette.softMint,
              entryModeIconColor: ReminderPalette.teal,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ReminderPalette.teal,
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
        backgroundColor: ReminderPalette.bg,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              const ReminderTopBackground(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                  child: Column(
                    children: [
                      const ReminderHeader(),
                      const SizedBox(height: 28),
                      ReminderPanel(
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
