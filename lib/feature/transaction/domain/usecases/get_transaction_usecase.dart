import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class GetTransactionUsecase {
  GetTransactionUsecase(this.repository);

  final TransactionRepository repository;

  Future<Either<AppFailure, List<TransactionEntity>>> call() {
    return repository.getTransaction();
  }
}
