import 'package:expense_tracker/feature/reminder/domain/repository/reminder_local_repository.dart';

class ClearReminderUsecase {
  final ReminderLocalRepository _repository;

  const ClearReminderUsecase(this._repository);

  Future<void> call() async {
    await _repository.clearReminder();
  }
}
