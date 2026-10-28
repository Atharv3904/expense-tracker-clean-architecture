import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check whether the device supports biometric authentication.
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isSupported = await _localAuth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await _localAuth
          .getAvailableBiometrics();

      return isSupported && availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Ask the user to authenticate using the device's biometrics.
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to log in to Spendly',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
