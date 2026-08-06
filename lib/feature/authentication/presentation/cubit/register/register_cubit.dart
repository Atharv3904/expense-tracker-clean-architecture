import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/authentication/domain/params/register_params.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/register_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/register/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterCubit(this.registerUsecase) : super(const RegisterInitial());

  Future<void> register(RegisterParams params) async {
    emit(const RegisterLoading());
    final result = await registerUsecase(params);
    result.fold(
      (failure) {
        emit(RegisterFailure(failure.message));
      },
      (user) {
        emit(RegisterSuccess());
      },
    );
  }
}
