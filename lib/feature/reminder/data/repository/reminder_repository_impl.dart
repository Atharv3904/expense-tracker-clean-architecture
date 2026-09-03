import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_datasource.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderDatasource reminderDatasource;

  const ReminderRepositoryImpl(this.reminderDatasource);

  @override
  Future<Either<AppFailure, void>> scheduleDailyReminder(
    ReminderEntity reminder,
  ) async {
    try {
      await reminderDatasource.scheduleDailyReminder(reminder);
      return Right(null);
    } on ReminderException catch (e) {
      return Left(ReminderFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, void>> cancelDailyReminder() async {
    try {
      await reminderDatasource.cancelDailyReminder();
      return Right(null);
    } on ReminderException catch (e) {
      return Left(ReminderFailure(e.message));
    }
  }
}
