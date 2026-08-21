import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/get_all_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_categories_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_types_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUsecase addTransactionUsecase;
  final GetTransactionUsecase getTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  final GetAllTransactionUsecase getAllTransactionUsecase;
  final TransactionTypesUsecase transactionTypesUsecase;
  final TransactionCategoriesUsecase transactionCategoriesUsecase;

  TransactionBloc({
    required this.addTransactionUsecase,
    required this.deleteTransactionUsecase,
    required this.getTransactionUsecase,
    required this.updateTransactionUsecase,
    required this.getAllTransactionUsecase,
    required this.transactionTypesUsecase,
    required this.transactionCategoriesUsecase,
  }) : super(const TransactionInitial()) {
    on<LoadTransaction>(_loadTransactions);

    on<AddTransaction>(_addTransaction);

    on<UpdateTransaction>(_updateTransaction);

    on<DeleteTransaction>(_deleteTransaction);

    on<GetAllTransaction>(_getAllTransaction);

    on<GetTypesTransaction>(_getTypesTransaction);

    on<GetCategoryTransaction>(_getCategoryTransaction);
  }

  Future<void> _getTypesTransaction(
    GetTypesTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

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

  Future<void> _getCategoryTransaction(
    GetCategoryTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await transactionCategoriesUsecase();

    result.fold(
      (failure) {
        emit(CategoryFailure(failure.message));
      },
      (category) {
        emit(CategoryLoaded(category));
      },
    );
  }

  Future<void> _getAllTransaction(
    GetAllTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    final result = await getAllTransactionUsecase();

    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (transactions) {
        emit(TransactionLoaded(transactions));
      },
    );
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
    emit(const TransactionLoading());

    final result = await getTransactionUsecase();

    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (transactions) {
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
      },
    );
  }

  Future<void> _deleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await deleteTransactionUsecase(event.transactionid);
    result.fold(
      (failure) {
        emit(TransactionFailure(failure.message));
      },
      (_) {
        emit(const TransactionDeleteSuccess());
        add(const GetAllTransaction());
      },
    );
  }
}
