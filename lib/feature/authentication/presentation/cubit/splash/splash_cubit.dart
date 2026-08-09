import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  SplashCubit(this.getCurrentUserUseCase) : super(SplashInitial());

  Future<void> checkAuthethication() async {
    emit(SplashLoading());
    final user = await getCurrentUserUseCase();

    user.fold(
      (failure) {
        emit(SplashUnauthenticated());
      },
      (user) {
        if (user == null) {
          emit(SplashUnauthenticated());
        } else {
          emit(SplashAuthenticated());
        }
      },
    );
  }
}
