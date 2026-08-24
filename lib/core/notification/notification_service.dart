import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (kIsWeb) return;

    // Ask user for notification permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notification initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings: initializationSettings);

    // Get Firebase Cloud Messaging token
    final token = await _firebaseMessaging.getToken();

    debugPrint('FCM TOKEN: $token');

    // Receive Firebase notifications while app is open
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // Call Supabase Edge Function
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-notification',
        body: {'user_id': userId, 'title': title, 'body': body},
      );

      debugPrint('Notification response: ${response.data}');
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'expense_tracker_channel',
      'Expense Tracker Notifications',
      channelDescription: 'Expense Tracker notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
    );
  }
}
