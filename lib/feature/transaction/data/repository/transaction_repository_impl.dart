import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource datasource;

  TransactionRepositoryImpl(this.datasource);

  @override
  AppResult<List<TransactionEntity>> getAllTransactionData({
    String? searchQuery,
  }) async {
    try {
      final result = await datasource.getAllTransactionData(
        searchQuery: searchQuery,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  AppResult<List<TransactionEntity>> getTransaction() async {
    try {
      final result = await datasource.getTransaction();

      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  AppResult<TransactionEntity> addTransaction(TransactionParam param) async {
    try {
      final result = await datasource.addTransaction(param);

      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  AppResult<TransactionEntity> updateTransaction(
    TransactionParam params,
  ) async {
    try {
      final result = await datasource.updateTransaction(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  AppResult<void> deleteTransaction(String transactionid) async {
    try {
      await datasource.deleteTransaction(transactionid);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(AppFailure(e.message));
    }
  }
}
