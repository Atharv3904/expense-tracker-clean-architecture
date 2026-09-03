import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_repository.dart';

class CancelDailyReminderUsecase {
  final ReminderRepository _reminderRepository;

  CancelDailyReminderUsecase(this._reminderRepository);

  Future<Either<AppFailure, void>> call() async {
    return await _reminderRepository.cancelDailyReminder();
  }
}
