import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderEvent {
  const ReminderEvent();
}

class ScheduleReminder extends ReminderEvent {
  final ReminderEntity reminder;
  const ScheduleReminder(this.reminder);
}

class CancelReminder extends ReminderEvent {
  const CancelReminder();
}
