import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderRepository {
  Future<Either<AppFailure, void>> scheduleDailyReminder(
    ReminderEntity reminder,
  );

  Future<Either<AppFailure, void>> cancelDailyReminder();
}
