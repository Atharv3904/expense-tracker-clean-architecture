import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<TransactionModel>> getAllTransactionData() async {
    final userId = supabaseClient.auth.currentUser!.id;
    try {
      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException("Failed to get transaction");
    }
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final userId = supabaseClient.auth.currentUser!.id;
    try {
      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false)
          .limit(3);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException("Failed to get transaction");
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    final userId = supabaseClient.auth.currentUser!.id;
    try {
      final data = transaction.toJson();
      data['user_id'] = userId;
      print('DATA SENT TO SUPABASE: $data');
      final response = await supabaseClient
          .from('transactions')
          .insert(data)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    final data = transaction.toJson();
    try {
      final response = await supabaseClient
          .from('transactions')
          .update(data)
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw ServerException("Failed to update transaction");
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      print('DELETE REQUEST ID: $transactionId');

      final response = await supabaseClient
          .from('transactions')
          .delete()
          .eq('id', transactionId)
          .select();

      print('DELETE RESPONSE: $response');
    } catch (e) {
      print('DELETE ERROR: $e');

      throw ServerException('Failed to delete transaction');
    }
  }
}
