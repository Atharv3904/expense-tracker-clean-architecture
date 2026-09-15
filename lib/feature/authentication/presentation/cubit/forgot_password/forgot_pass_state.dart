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

  const ForgotPassFailure(this.message);
}

class UpdatePasswordLoading extends ForgotPassState {
  const UpdatePasswordLoading();
}

class UpdatePasswordSuccess extends ForgotPassState {
  const UpdatePasswordSuccess();
}

class UpdatePasswordFailure extends ForgotPassState {
  final String message;

  const UpdatePasswordFailure(this.message);
}
