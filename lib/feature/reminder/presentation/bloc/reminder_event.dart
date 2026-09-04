import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderEvent {
  const ReminderEvent();
}

/// Load the saved reminder when ReminderPage opens.
class LoadReminder extends ReminderEvent {
  const LoadReminder();
}

/// Schedule the notification and save the reminder settings.
class ScheduleReminder extends ReminderEvent {
  final ReminderEntity reminder;

  const ScheduleReminder(this.reminder);
}

/// Cancel the notification and clear the saved reminder settings.
class CancelReminder extends ReminderEvent {
  const CancelReminder();
}
