import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricCredentialLocalDatasourceService {
  BiometricCredentialLocalDatasourceService()
    : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _lastBiometricUserKey = 'biometric_login_last_user_id';

  String _emailKey(String userId) => 'biometric_login_${userId}_email';

  String _passwordKey(String userId) => 'biometric_login_${userId}_password';

  String _enabledKey(String userId) => 'biometric_login_${userId}_enabled';

  Future<bool> isEnabled(String userId) async {
    return await _storage.read(key: _enabledKey(userId)) == 'true';
  }

  Future<void> enable({
    required String userId,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _emailKey(userId), value: email);
    await _storage.write(key: _passwordKey(userId), value: password);
    await _storage.write(key: _enabledKey(userId), value: 'true');
    await setLastBiometricUser(userId);
  }

  Future<({String email, String password})?> getCredentials(
    String userId,
  ) async {
    if (!await isEnabled(userId)) return null;

    final email = await _storage.read(key: _emailKey(userId));
    final password = await _storage.read(key: _passwordKey(userId));

    if (email == null || password == null) return null;

    return (email: email, password: password);
  }

  Future<void> disable(String userId) async {
    await _storage.delete(key: _emailKey(userId));
    await _storage.delete(key: _passwordKey(userId));
    await _storage.delete(key: _enabledKey(userId));
    await clearLastBiometricUser(userId);
  }

  Future<void> setLastBiometricUser(String userId) async {
    await _storage.write(key: _lastBiometricUserKey, value: userId);
  }

  Future<String?> getLastBiometricUser() async {
    return _storage.read(key: _lastBiometricUserKey);
  }

  Future<void> clearLastBiometricUser(String userId) async {
    final savedUserId = await getLastBiometricUser();

    if (savedUserId == userId) {
      await _storage.delete(key: _lastBiometricUserKey);
    }
  }
}
