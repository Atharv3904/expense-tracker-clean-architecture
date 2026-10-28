sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final String role;
  final String? userId;
  final String? email;
  final bool isBiometricLogin;

  const LoginSuccess({
    required this.role,
    this.userId,
    this.email,
    this.isBiometricLogin = false,
  });
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}
