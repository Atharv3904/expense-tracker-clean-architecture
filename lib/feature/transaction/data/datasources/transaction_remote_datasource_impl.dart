import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final userId = supabaseClient.auth.currentUser!.id;

    final response = await supabaseClient
        .from('trasactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    final userId = supabaseClient.auth.currentUser!.id;

    final data = transaction.toJson();
    data['user_id'] = userId;

    final response = await supabaseClient
        .from('transactions')
        .insert(data)
        .select()
        .single();

    return TransactionModel.fromJson(response);
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    final data = transaction.toJson();
    final response = await supabaseClient
        .from('transactions')
        .update(data)
        .eq('id', transaction.id)
        .select()
        .single();

    return TransactionModel.fromJson(response);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await supabaseClient.from('transactions').delete().eq('id', transactionId);
  }
}
