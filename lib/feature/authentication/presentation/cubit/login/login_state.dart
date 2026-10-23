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
  const LoginSuccess({required this.role});
}

final class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}
