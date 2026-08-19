import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class DeleteTransactionUsecase {
  final TransactionRepository repository;

  DeleteTransactionUsecase(this.repository);

  Future<Either<AppFailure, void>> call(String transactionid) {
    return repository.deleteTransaction(transactionid);
  }
}
