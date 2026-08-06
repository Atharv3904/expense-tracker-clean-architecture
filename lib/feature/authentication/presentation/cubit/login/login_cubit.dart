import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUseCase;
  LoginCubit(this.loginUseCase) : super(const LoginInitial());

  Future<void> login(LoginParams params) async {
    emit(const LoginLoading());

    final result = await loginUseCase(params);

    result.fold(
      (failure) {
        emit(LoginFailure(failure.message));
      },
      (user) {
        emit(LoginSuccess());
      },
    );
  }
}
