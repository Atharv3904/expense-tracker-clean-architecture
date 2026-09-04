import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_repository.dart';

class ScheduleDailyReminderUsecase {
  final ReminderRepository _reminderRepository;

  ScheduleDailyReminderUsecase(this._reminderRepository);

  AppResult<void> call(ReminderEntity reminder) async {
    return await _reminderRepository.scheduleDailyReminder(reminder);
  }
}
