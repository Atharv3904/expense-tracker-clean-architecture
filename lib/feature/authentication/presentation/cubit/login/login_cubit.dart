import 'package:bloc/bloc.dart';
import 'package:expense_tracker/core/services/biometric_service.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/biometric_credential_local_datasource_service.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/get_profile_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUseCase;
  final GetProfileUsecase getProfileUsecase;
  final BiometricService biometricService;
  final BiometricCredentialLocalDatasourceService
  biometricCredentialLocalDatasourceService;

  // Kept temporarily in memory only while the opt-in decision is pending.
  // Never add this password to LoginState.
  String? _pendingPasswordForBiometricOptIn;

  LoginCubit({
    required this.loginUseCase,
    required this.getProfileUsecase,
    required this.biometricService,
    required this.biometricCredentialLocalDatasourceService,
  }) : super(const LoginInitial());

  /// Normal email/password login.
  Future<void> login(LoginParams params) async {
    clearPendingBiometricOptIn();
    _pendingPasswordForBiometricOptIn = params.password;

    emit(const LoginLoading());

    try {
      final result = await loginUseCase(params);

      await result.fold(
        (failure) async {
          clearPendingBiometricOptIn();
          emit(LoginFailure(failure.message));
        },
        (user) async {
          await _loadUserProfile(
            userId: user.id,
            email: user.email,
            isBiometricLogin: false,
          );
        },
      );

      if (state is LoginFailure) {
        clearPendingBiometricOptIn();
      }
    } catch (_) {
      clearPendingBiometricOptIn();
      emit(const LoginFailure('Unable to log in. Please try again.'));
    }
  }

  /// Check whether biometric authentication is available.
  Future<bool> isBiometricAvailable() {
    return biometricService.isBiometricAvailable();
  }

  /// Check whether this account has enabled biometric login.
  Future<bool> isBiometricEnabled(String userId) {
    return biometricCredentialLocalDatasourceService.isEnabled(userId);
  }

  /// Clear the temporary password when the user declines opt-in.
  void clearPendingBiometricOptIn() {
    _pendingPasswordForBiometricOptIn = null;
  }

  /// Save credentials only after the user explicitly opts in.
  Future<void> enableBiometricLoginForPendingUser({
    required String userId,
    required String email,
  }) async {
    final currentState = state;

    if (currentState is! LoginSuccess ||
        currentState.isBiometricLogin ||
        currentState.userId != userId ||
        currentState.email != email) {
      clearPendingBiometricOptIn();
      throw Exception('The login session is no longer valid.');
    }

    final password = _pendingPasswordForBiometricOptIn;

    if (password == null || password.isEmpty) {
      throw Exception('The temporary login credentials are unavailable.');
    }

    try {
      final available = await biometricService.isBiometricAvailable();

      if (!available) {
        throw Exception('No enrolled biometrics are available on this device.');
      }

      await biometricCredentialLocalDatasourceService.enable(
        userId: userId,
        email: email,
        password: password,
      );
    } finally {
      clearPendingBiometricOptIn();
    }
  }

  /// Biometric authentication followed by the existing Supabase login.
  Future<void> loginWithBiometrics(String userId) async {
    clearPendingBiometricOptIn();
    emit(const LoginLoading());

    try {
      final enabled = await biometricCredentialLocalDatasourceService.isEnabled(
        userId,
      );

      if (!enabled) {
        emit(
          const LoginFailure(
            'Fingerprint login is not enabled for this account.',
          ),
        );
        return;
      }

      final available = await biometricService.isBiometricAvailable();

      if (!available) {
        emit(
          const LoginFailure(
            'No enrolled biometrics are available on this device.',
          ),
        );
        return;
      }

      final authenticated = await biometricService.authenticate();

      if (!authenticated) {
        emit(
          const LoginFailure(
            'Biometric authentication was cancelled or unsuccessful.',
          ),
        );
        return;
      }

      final credentials = await biometricCredentialLocalDatasourceService
          .getCredentials(userId);

      if (credentials == null) {
        emit(
          const LoginFailure(
            'Saved login credentials were not found. Please log in normally.',
          ),
        );
        return;
      }

      final result = await loginUseCase(
        LoginParams(email: credentials.email, password: credentials.password),
      );

      await result.fold(
        (failure) async {
          await biometricCredentialLocalDatasourceService.disable(userId);
          emit(
            const LoginFailure(
              'Biometric login failed. Please log in with your password.',
            ),
          );
        },
        (user) async {
          await _loadUserProfile(
            userId: user.id,
            email: user.email,
            isBiometricLogin: true,
          );
        },
      );
    } catch (_) {
      emit(
        const LoginFailure(
          'Unable to complete biometric login. Please try normal login.',
        ),
      );
    }
  }

  /// Load the profile and validate the user's role.
  Future<void> _loadUserProfile({
    required String userId,
    required String email,
    required bool isBiometricLogin,
  }) async {
    try {
      final profileResult = await getProfileUsecase();

      profileResult.fold(
        (failure) {
          emit(LoginFailure(failure.message));
        },
        (profile) {
          final role = profile.role;

          if (role != 'user' && role != 'admin') {
            emit(const LoginFailure('Invalid or missing user role'));
            return;
          }

          emit(
            LoginSuccess(
              role: role!,
              userId: userId,
              email: email,
              isBiometricLogin: isBiometricLogin,
            ),
          );
        },
      );
    } catch (_) {
      emit(
        const LoginFailure('Unable to load your profile. Please try again.'),
      );
    }
  }

  /// Find the account configured for biometric login.
  Future<String?> getBiometricUserId() async {
    try {
      final userId = await biometricCredentialLocalDatasourceService
          .getLastBiometricUser();

      if (userId == null || userId.isEmpty) {
        return null;
      }

      final enabled = await biometricCredentialLocalDatasourceService.isEnabled(
        userId,
      );

      return enabled ? userId : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    clearPendingBiometricOptIn();
    return super.close();
  }
}
