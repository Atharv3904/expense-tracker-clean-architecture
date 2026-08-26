import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceTokenService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> saveToken() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return;

    String? token;

    if (kIsWeb) {
      token = await _messaging.getToken(
        vapidKey:
            'BJrmxmUPd3i4cQik-7i1KwXVmhiEwzKBpZ-hVYGG6Fv76_QPVLjC5-2heLSLhy37pSOumiePR41iNzheAIurxi8',
      );
    } else {
      token = await _messaging.getToken();
    }

    if (token == null) return;

    await _supabase.from('device_tokens').upsert({
      'user_id': user.id,
      'fcm_token': token,
      'platform': kIsWeb ? 'web' : 'android',
    }, onConflict: 'user_id,fcm_token');
  }

  void listenForTokenRefresh() {
    if (kIsWeb) return;
    _messaging.onTokenRefresh.listen((newToken) async {
      final user = _supabase.auth.currentUser;

      if (user == null) return;

      await _supabase.from('device_tokens').upsert({
        'user_id': user.id,
        'fcm_token': newToken,
        'platform': 'android',
      });
    });
  }
}
