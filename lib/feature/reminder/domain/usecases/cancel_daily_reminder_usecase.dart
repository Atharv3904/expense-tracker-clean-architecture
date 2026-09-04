import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_repository.dart';

class CancelDailyReminderUsecase {
  final ReminderRepository _reminderRepository;

  CancelDailyReminderUsecase(this._reminderRepository);

  AppResult<void> call() async {
    return await _reminderRepository.cancelDailyReminder();
  }
}
