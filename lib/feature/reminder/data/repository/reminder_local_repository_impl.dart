import 'package:expense_tracker/feature/reminder/data/datasource/reminder_local_datasource.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_local_repository.dart';

class ReminderLocalRepositoryImpl implements ReminderLocalRepository {
  final ReminderLocalDatasource _reminderLocalDatasource;

  const ReminderLocalRepositoryImpl(this._reminderLocalDatasource);

  @override
  Future<void> saveReminder(ReminderEntity reminder) async {
    await _reminderLocalDatasource.saveReminder(reminder);
  }

  @override
  Future<ReminderEntity?> getReminder() async {
    return await _reminderLocalDatasource.getReminder();
  }

  @override
  Future<void> clearReminder() async {
    await _reminderLocalDatasource.clearReminder();
  }
}
