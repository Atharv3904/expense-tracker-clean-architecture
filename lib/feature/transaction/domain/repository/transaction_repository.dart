import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';

abstract class TransactionRepository {
  //curd

  AppResult<List<TransactionEntity>> getAllTransactionData({
    String? searchQuery,
  });

  AppResult<List<TransactionEntity>> getTransaction();

  AppResult<TransactionEntity> addTransaction(TransactionParam param);

  AppResult<TransactionEntity> updateTransaction(TransactionEntity param);

  AppResult<void> deleteTransaction(String transactionid);
}
