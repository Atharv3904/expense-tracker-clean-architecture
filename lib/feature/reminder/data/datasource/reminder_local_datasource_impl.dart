import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_local_datasource.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderLocalDatasourceImpl implements ReminderLocalDatasource {
  final SharedPreferences _preferences;

  const ReminderLocalDatasourceImpl(this._preferences);

  static const String _enabledKey = 'daily_reminder_enabled';
  static const String _hourKey = 'daily_reminder_hour';
  static const String _minuteKey = 'daily_reminder_minute';

  @override
  Future<void> saveReminder(ReminderEntity reminder) async {
    try {
      await _preferences.setBool(_enabledKey, reminder.dailyEnabled);

      await _preferences.setInt(_hourKey, reminder.hour);

      await _preferences.setInt(_minuteKey, reminder.minute);
    } catch (e) {
      throw SharedPrefException("your reminder is not saved");
    }
  }

  @override
  Future<ReminderEntity?> getReminder() async {
    try {
      final enable = _preferences.getBool(_enabledKey);

      if (enable == null) {
        return null;
      }

      final hour = _preferences.getInt(_hourKey) ?? 20;
      final minute = _preferences.getInt(_minuteKey) ?? 0;

      return ReminderEntity(dailyEnabled: enable, hour: hour, minute: minute);
    } catch (e) {
      throw SharedPrefException("this time... can't get your reminder");
    }
  }

  @override
  Future<void> clearReminder() async {
    try {
      await _preferences.remove(_enabledKey);
      await _preferences.remove(_hourKey);
      await _preferences.remove(_minuteKey);
    } catch (e) {
      throw SharedPrefException("reminder is not cleared");
    }
  }
}
