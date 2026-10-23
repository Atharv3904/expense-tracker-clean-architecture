import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/params/login_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_state.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/get_profile_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUseCase;
  final GetProfileUsecase getProfileUsecase;

  LoginCubit({required this.loginUseCase, required this.getProfileUsecase})
    : super(const LoginInitial());

  Future<void> login(LoginParams params) async {
    emit(const LoginLoading());

    final loginResult = await loginUseCase(params);

    await loginResult.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        final profileResult = await getProfileUsecase();

        profileResult.fold(
          (failure) {
            emit(LoginFailure(failure.message));
          },
          (profile) {
            final role = profile.role;

            if (role != 'user' && role != 'admin') {
              emit(LoginFailure('Invalid or missing user role'));
              return;
            }

            emit(LoginSuccess(role: role!));
          },
        );
      },
    );
  }
}
