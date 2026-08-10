import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';

class ForgotPassCubit extends Cubit<ForgotPassState> {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  ForgotPassCubit(this.forgotPasswordUsecase)
    : super(const ForgotPassInitial());

  Future<void> forgotPassword(ForgotPasswordParams email) async {
    emit(ForgotPassLoading());

    final result = await forgotPasswordUsecase(email);

    result.fold(
      (failure) => {emit(ForgotPassFailure(failure.message))},
      (_) => {emit(const ForgotPassSuccess())},
    );
  }
}
