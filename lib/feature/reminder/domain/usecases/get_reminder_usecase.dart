import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_local_repository.dart';

class GetReminderUsecase {
  final ReminderLocalRepository _repository;

  const GetReminderUsecase(this._repository);

  Future<ReminderEntity?> call() async {
    return await _repository.getReminder();
  }
}
