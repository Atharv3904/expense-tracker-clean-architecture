import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class UpdateTransactionUsecase {
  final TransactionRepository repository;
  const UpdateTransactionUsecase(this.repository);

  Future<Either<AppFailure, TransactionEntity>> call(
    TransactionEntity transaction,
  ) {
    return repository.updateTransaction(transaction);
  }
}
