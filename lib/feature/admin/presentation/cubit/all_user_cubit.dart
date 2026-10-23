import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/admin/domain/usecases/get_all_user_usecase.dart';
import 'package:expense_tracker/feature/admin/presentation/cubit/all_user_state.dart';

class AllUserCubit extends Cubit<AllUserState> {
  final GetAllUserUsecase _getAllUserUsecase;

  AllUserCubit(this._getAllUserUsecase) : super(AllUserInitial());

  Future<void> getAllUsers() async {
    emit(AllUserLoading());

    final result = await _getAllUserUsecase();

    result.fold(
      (failure) {
        emit(AllUserError(message: failure.message));
      },
      (users) {
        emit(AllUserLoaded(users: users));
      },
    );
  }
}
