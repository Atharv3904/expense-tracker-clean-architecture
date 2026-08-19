import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource datasource;

  TransactionRepositoryImpl(this.datasource);

  @override
  Future<Either<AppFailure, List<TransactionEntity>>>
  getAllTransactionData() async {
    try {
      final result = await datasource.getAllTransactionData();
      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, List<TransactionEntity>>> getTransaction() async {
    try {
      final result = await datasource.getTransaction();
      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, TransactionEntity>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        amount: transaction.amount,
        typeId: transaction.typeId,
        categoryId: transaction.categoryId,
        description: transaction.description,
        date: transaction.date,
      );

      final result = await datasource.addTransaction(model);
      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        amount: transaction.amount,
        typeId: transaction.typeId,
        categoryId: transaction.categoryId,
        description: transaction.description,
        date: transaction.date,
      );

      final result = await datasource.updateTransaction(model);
      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteTransaction(
    String transactionid,
  ) async {
    try {
      await datasource.deleteTransaction(transactionid);
      return Right(null);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }
}
