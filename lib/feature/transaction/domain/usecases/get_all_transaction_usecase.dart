import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class GetAllTransactionUsecase {
  final TransactionRepository repository;
  GetAllTransactionUsecase(this.repository);

  Future<Either<AppFailure, List<TransactionEntity>>> call() async {
    return repository.getAllTransactionData();
  }
}
