import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;
  LogoutCubit(this.logoutUseCase) : super(const LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
