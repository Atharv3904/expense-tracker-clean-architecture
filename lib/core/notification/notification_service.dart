import 'package:expense_tracker/core/notification/%20android_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationService _androidNotification =
      AndroidNotificationService();

  Future<void> initialize() async {
    debugPrint('🔔 NotificationService.initialize() CALLED');

    // ==========================================
    // FIREBASE PERMISSION
    // ==========================================

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ==========================================
    // ANDROID
    // ==========================================

    if (!kIsWeb) {
      await _androidNotification.initialize();
    }

    // ==========================================
    // WEB
    // ==========================================

    // ==========================================
    // FCM TOKEN
    // ==========================================

    final token = await _firebaseMessaging.getToken(
      vapidKey: kIsWeb
          ? 'BJrmxmUPd3i4cQik-7i1KwXVmhiEwzKBpZ-hVYGG6Fv76_QPVLjC5-2heLSLhy37pSOumiePR41iNzheAIurxi8'
          : null,
    );

    debugPrint('FCM TOKEN: $token');

    // ==========================================
    // FOREGROUND MESSAGE
    // ==========================================

    debugPrint('🔔 Registering Firebase onMessage listener');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // ==========================================
  // SEND NOTIFICATION THROUGH SUPABASE
  // ==========================================

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

  // ==========================================
  // FOREGROUND FCM MESSAGE
  // ==========================================

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) {
      debugPrint('⚠️ FCM message has no notification payload');
      return;
    }

    final title = notification.title ?? 'Expense Tracker';

    final body = notification.body ?? '';

    debugPrint('========== FCM MESSAGE ==========');

    debugPrint('TITLE: $title');
    debugPrint('BODY: $body');
    debugPrint('DATA: ${message.data}');

    debugPrint('=================================');

    // ==========================================
    // WEB
    // ==========================================

    // ==========================================
    // ANDROID
    // ==========================================

    try {
      await _androidNotification.show(
        id: notification.hashCode,
        title: title,
        body: body,
      );

      debugPrint('✅ ANDROID NOTIFICATION SHOWN');
    } catch (e) {
      debugPrint('❌ ANDROID NOTIFICATION ERROR: $e');
    }
  }
}
