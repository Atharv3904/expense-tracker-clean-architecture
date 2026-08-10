class ForgotPassState {
  const ForgotPassState();
}

class ForgotPassInitial extends ForgotPassState {
  const ForgotPassInitial();
}

class ForgotPassLoading extends ForgotPassState {
  const ForgotPassLoading();
}

class ForgotPassSuccess extends ForgotPassState {
  const ForgotPassSuccess();
}

class ForgotPassFailure extends ForgotPassState {
  final String message;
  ForgotPassFailure(this.message);
}
