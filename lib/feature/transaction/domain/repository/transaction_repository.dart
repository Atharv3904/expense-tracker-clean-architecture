import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  //curd

  Future<Either<AppFailure, List<TransactionEntity>>> getTransaction();

  Future<Either<AppFailure, TransactionEntity>> addTransaction(
    TransactionEntity transaction,
  );

  Future<Either<AppFailure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  );

  Future<Either<AppFailure, void>> deleteTransaction(String TransactionId);
}
