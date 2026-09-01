import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_types_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_states.dart';

class TypeBloc extends Bloc<TypeEvent, TypeStates> {
  final TransactionTypesUsecase transactionTypesUsecase;
  TypeBloc({required this.transactionTypesUsecase})
    : super(const TypeInitial()) {
    on<GetTypesTransaction>(_getTypesTransaction);
  }

  Future<void> _getTypesTransaction(
    GetTypesTransaction event,
    Emitter<TypeStates> emit,
  ) async {
    emit(TypeLoading());

    final result = await transactionTypesUsecase();

    result.fold(
      (failure) {
        emit(TypeFailure(failure.message));
      },
      (types) {
        emit(TypeLoaded(types));
      },
    );
  }
}
