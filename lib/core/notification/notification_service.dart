import 'package:expense_tracker/core/notification/%20android_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationService _androidNotification =
      AndroidNotificationService();

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (!kIsWeb) {
      await _androidNotification.initialize();
    }

    await _firebaseMessaging.getToken(
      vapidKey: kIsWeb
          ? 'BJrmxmUPd3i4cQik-7i1KwXVmhiEwzKBpZ-hVYGG6Fv76_QPVLjC5-2heLSLhy37pSOumiePR41iNzheAIurxi8'
          : null,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      await Supabase.instance.client.functions.invoke(
        'send-notification',
        body: {'user_id': userId, 'title': title, 'body': body},
      );
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) {
      return;
    }

    final title = notification.title ?? 'Expense Tracker';

    final body = notification.body ?? '';

    try {
      await _androidNotification.show(
        id: notification.hashCode,
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint(' ANDROID NOTIFICATION ERROR: $e');
    }
  }
}
