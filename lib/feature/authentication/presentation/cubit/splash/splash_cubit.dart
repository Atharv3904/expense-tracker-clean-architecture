import 'package:bloc/bloc.dart';
import 'package:expense_tracker/core/services/biometric_service.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/biometric_credential_local_datasource_service.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final BiometricService biometricService;
  final BiometricCredentialLocalDatasourceService
      biometricCredentialLocalDatasourceService;

  SplashCubit({
    required this.getCurrentUserUseCase,
    required this.biometricService,
    required this.biometricCredentialLocalDatasourceService,
  }) : super(const SplashInitial());

  Future<void> checkAuthethication() async {
    emit(const SplashLoading());

    try {
      final result = await getCurrentUserUseCase();

      await result.fold(
        (failure) async {
          emit(const SplashUnauthenticated());
        },
        (user) async {
          if (user == null) {
            emit(const SplashUnauthenticated());
            return;
          }

          final role = user.role;
          final isAvailable = await biometricService.isBiometricAvailable();
          final isEnabled = await biometricCredentialLocalDatasourceService
              .isEnabled(user.id);

          if (!isAvailable || !isEnabled) {
            // Biometric is disabled or unsupported: restore session directly to Dashboard.
            emit(SplashAuthenticated(role: role));
            return;
          }

          // Biometric is enabled: require authentication on fresh app launch.
          emit(
            SplashBiometricRequired(
              role: role,
              userId: user.id,
              email: user.email,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const SplashUnauthenticated());
    }
  }

  Future<void> authenticateBiometric({required String role}) async {
    final result = await biometricService.authenticateWithResult(
      localizedReason: 'Authenticate to access Spendly',
    );

    if (result == BiometricAuthResult.success) {
      emit(SplashAuthenticated(role: role));
    } else {
      // Fingerprint failure or cancellation: do not enter Dashboard, fallback to normal login.
      emit(const SplashUnauthenticated());
    }
  }
}
