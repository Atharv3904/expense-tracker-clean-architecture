import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUsecase addTransactionUsecase;
  final GetTransactionUsecase getTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;

  TransactionBloc({
    required this.addTransactionUsecase,
    required this.deleteTransactionUsecase,
    required this.getTransactionUsecase,
    required this.updateTransactionUsecase,
  }) : super(const TransactionInitial()) {
    on<LoadTransaction>(_loadTransactions);

    on<AddTransaction>(_addTransaction);

    on<UpdateTransaction>(_updateTransaction);

    on<DeleteTransaction>(_deleteTransaction);
  }

  Future<void> _addTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await addTransactionUsecase(event.transaction);

    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (_) {
        emit(TransactionSuccess());
        add(const LoadTransaction());
      },
    );
  }

  Future<void> _loadTransactions(
    LoadTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    print('LOAD TRANSACTION EVENT RECEIVED');
    emit(const TransactionLoading());

    final result = await getTransactionUsecase();

    result.fold(
      (failure) {
        print('LOAD FAILED: ${failure.message}');
        emit(TransactionFailure(failure.message));
      },
      (transactions) {
        print('TRANSACTIONS LOADED: ${transactions.length}');
        emit(TransactionLoaded(transactions));
      },
    );
  }

  Future<void> _updateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await updateTransactionUsecase(event.transaction);

    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (_) {
        emit(TransactionSuccess());
        add(const LoadTransaction());
      },
    );
  }

  Future<void> _deleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await deleteTransactionUsecase(event.TransactionId);
    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (_) {
        emit(const TransactionSuccess());

        add(const LoadTransaction());
      },
    );
  }
}
