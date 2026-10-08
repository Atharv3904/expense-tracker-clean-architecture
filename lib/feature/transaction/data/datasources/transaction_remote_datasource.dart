import 'dart:core';

import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';

import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';

abstract class TransactionRemoteDatasource {
  Future<List<TransactionModel>> getAllTransactionData({String? searchQuery});
  Future<List<TransactionModel>> getTransaction();
  Future<TransactionModel> addTransaction(TransactionParam param);
  Future<TransactionModel> updateTransaction(TransactionParam param);
  Future<void> deleteTransaction(String transactionid);
}
