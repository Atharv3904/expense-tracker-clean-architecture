import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_type_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'transaction_type_remote_datasource.dart';

class TransactionTypeRemoteDatasourceImpl
    implements TransactionTypeRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionTypeRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<TransactionTypeModel>> getTypes() async {
    try {
      final response = await supabaseClient.from('transaction_types').select();

      return (response as List)
          .map((json) => TransactionTypeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw TypeException("check your Internet connection");
    }
  }
}
