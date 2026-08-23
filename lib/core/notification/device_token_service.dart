import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceTokenService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> saveToken() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return;

    final token = await _messaging.getToken();

    if (token == null) return;

    await _supabase.from('device_tokens').upsert({
      'user_id': user.id,
      'fcm_token': token,
      'platform': 'android',
    }, onConflict: 'user_id,fcm_token');
  }

  void listenForTokenRefresh() {
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
