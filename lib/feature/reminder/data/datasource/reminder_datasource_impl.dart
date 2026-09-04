import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/notification/%20android_notification_service.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_datasource.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

class ReminderDatasourceImpl implements ReminderDatasource {
  final AndroidNotificationService _androidNotificationService;
  const ReminderDatasourceImpl(this._androidNotificationService);

  @override
  Future<void> scheduleDailyReminder(ReminderEntity reminder) async {
    if (!reminder.dailyEnabled) {
      await cancelDailyReminder();
      return;
    }
    try {
      await _androidNotificationService.scheduleDaily(
        id: 1001,
        title: '💰 Expense Tracker',
        body: "Don't forget to add today's income and expenses.",
        hour: reminder.hour,
        minute: reminder.minute,
      );
    } catch (e) {
      throw ReminderException("your reminder is not scheduled...");
    }
  }

  @override
  Future<void> cancelDailyReminder() async {
    try {
      await _androidNotificationService.cancel(id: 1001);
    } catch (e) {
      throw ReminderException("your reminder is not cancled...");
    }
  }
}
