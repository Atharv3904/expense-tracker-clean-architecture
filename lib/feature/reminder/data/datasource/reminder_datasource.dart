import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderDatasource {
  Future<void> scheduleDailyReminder(ReminderEntity reminder);

  Future<void> cancelDailyReminder();
}
