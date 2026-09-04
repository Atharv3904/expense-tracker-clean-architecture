import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_local_repository.dart';

class SaveReminderUsecase {
  final ReminderLocalRepository _repository;

  const SaveReminderUsecase(this._repository);

  Future<void> call(ReminderEntity reminder) async {
    await _repository.saveReminder(reminder);
  }
}
