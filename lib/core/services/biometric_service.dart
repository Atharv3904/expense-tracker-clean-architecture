import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricAuthResult {
  success,
  cancelled,
  notEnrolled,
  notAvailable,
  failure,
}

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check whether the device supports biometric authentication and has enrolled biometrics.
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await _localAuth
          .getAvailableBiometrics();

      return (canCheck || isSupported) && availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Authenticate using biometrics and return a detailed result.
  Future<BiometricAuthResult> authenticateWithResult({
    String localizedReason = 'Authenticate to access Spendly',
  }) async {
    try {
      final available = await isBiometricAvailable();
      if (!available) {
        return BiometricAuthResult.notAvailable;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      return authenticated
          ? BiometricAuthResult.success
          : BiometricAuthResult.cancelled;
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        return BiometricAuthResult.notEnrolled;
      }
      if (e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code ==
              LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable) {
        return BiometricAuthResult.notAvailable;
      }
      if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        return BiometricAuthResult.failure;
      }
      return BiometricAuthResult.cancelled;
    } on PlatformException catch (_) {
      return BiometricAuthResult.cancelled;
    } catch (_) {
      return BiometricAuthResult.failure;
    }
  }

  /// Ask the user to authenticate using the device's biometrics.
  Future<bool> authenticate({
    String localizedReason = 'Authenticate to log in to Spendly',
  }) async {
    final result = await authenticateWithResult(
      localizedReason: localizedReason,
    );
    return result == BiometricAuthResult.success;
  }
}
