import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  //curd

  AppResult<List<TransactionEntity>> getAllTransactionData();

  AppResult<List<TransactionEntity>> getTransaction();

  AppResult<TransactionEntity> addTransaction(TransactionEntity transaction);

  AppResult<TransactionEntity> updateTransaction(TransactionEntity transaction);

  AppResult<void> deleteTransaction(String transactionid);
}
