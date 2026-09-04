import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_event.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_states.dart';
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

    // Load previously saved reminder from SharedPreferences.
    context.read<ReminderBloc>().add(const LoadReminder());
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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
        // Load saved reminder from SharedPreferences.
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🔕 Reminder cancelled')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Reminders')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: Text(
                  dailyEnabled ? 'Reminder is enabled' : 'Reminder is disabled',
                ),
                value: dailyEnabled,
                onChanged: (value) {
                  setState(() {
                    dailyEnabled = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              ListTile(
                title: const Text('Reminder Time'),
                subtitle: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: dailyEnabled ? selectTime : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveReminder,
                  child: const Text('Save Reminder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
