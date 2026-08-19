import 'dart:core';

import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  Future<List<TransactionModel>> getAllTransactionData();
  Future<List<TransactionModel>> getTransaction();
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionid);
}
