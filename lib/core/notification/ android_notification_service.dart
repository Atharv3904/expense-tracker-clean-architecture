import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AndroidNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize local notifications and timezone.
  Future<void> initialize() async {
    // Initialize timezone database.
    tz.initializeTimeZones();

    // Set India timezone.
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    debugPrint('LOCAL TIMEZONE: ${tz.local.name}');
    debugPrint('CURRENT TIME: ${tz.TZDateTime.now(tz.local)}');

    // Android notification settings.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings: initializationSettings);

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final notificationPermission = await androidPlugin
        ?.requestNotificationsPermission();

    debugPrint('NOTIFICATION PERMISSION: $notificationPermission');

    final exactAlarmPermission = await androidPlugin
        ?.requestExactAlarmsPermission();

    debugPrint('EXACT ALARM PERMISSION: $exactAlarmPermission');

    // Initialize notification plugin.
    await _notifications.initialize(settings: initializationSettings);
  }

  Future<void> testScheduledNotification() async {
    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = now.add(const Duration(seconds: 30));

    debugPrint('TEST NOW: $now');
    debugPrint('TEST SCHEDULED: $scheduledDate');

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Expense Tracker daily reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id: 9999,
      title: 'Expense Tracker',
      body: 'This is a test reminder.',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('TEST NOTIFICATION SCHEDULED');
  }

  // Show notification immediately.
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'expense_tracker_channel',
      'Expense Tracker Notifications',
      channelDescription: 'Expense Tracker notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  // Schedule a daily notification.
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If today's time has already passed,
    // schedule it for tomorrow.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('REMINDER REQUESTED: $hour:$minute');

    debugPrint('REMINDER SCHEDULED: $scheduledDate');

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Expense Tracker daily reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('LOCAL TIMEZONE: ${tz.local.name}');

    debugPrint('CURRENT TIME: ${tz.TZDateTime.now(tz.local)}');

    debugPrint('REMINDER SCHEDULED: $scheduledDate');

    debugPrint('REMINDER SCHEDULED SUCCESSFULLY');
  }

  // Cancel a scheduled notification.
  Future<void> cancel({required int id}) async {
    await _notifications.cancel(id: id);
  }
}
