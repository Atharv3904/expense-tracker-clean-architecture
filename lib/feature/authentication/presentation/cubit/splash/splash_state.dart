sealed class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashAuthenticated extends SplashState {
  final String role;

  const SplashAuthenticated({required this.role});
}

class SplashBiometricRequired extends SplashState {
  final String role;
  final String userId;
  final String email;

  const SplashBiometricRequired({
    required this.role,
    required this.userId,
    required this.email,
  });
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}
