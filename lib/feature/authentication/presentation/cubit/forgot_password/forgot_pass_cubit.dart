import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/params/forgot_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/params/update_password_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/update_password_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_state.dart';

class ForgotPassCubit extends Cubit<ForgotPassState> {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;

  ForgotPassCubit(this.forgotPasswordUsecase, this.updatePasswordUsecase)
    : super(const ForgotPassInitial());

  Future<void> forgotPassword(ForgotPasswordParams params) async {
    emit(const ForgotPassLoading());

    final result = await forgotPasswordUsecase(params);

    result.fold(
      (failure) {
        emit(ForgotPassFailure(failure.message));
      },
      (_) {
        emit(const ForgotPassSuccess());
      },
    );
  }

  Future<void> updatePassword(UpdatePasswordParams params) async {
    emit(const UpdatePasswordLoading());

    final result = await updatePasswordUsecase(params);

    result.fold(
      (failure) {
        emit(UpdatePasswordFailure(failure.message));
      },
      (_) {
        emit(const UpdatePasswordSuccess());
      },
    );
  }
}
