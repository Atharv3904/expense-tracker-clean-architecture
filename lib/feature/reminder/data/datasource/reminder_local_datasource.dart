import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderLocalDatasource {
  Future<void> saveReminder(ReminderEntity reminder);

  Future<ReminderEntity?> getReminder();
  Future<void> clearReminder();
}
