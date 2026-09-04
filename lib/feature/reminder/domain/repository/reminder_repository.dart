import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderRepository {
  AppResult<void> scheduleDailyReminder(ReminderEntity reminder);

  AppResult<void> cancelDailyReminder();
}
