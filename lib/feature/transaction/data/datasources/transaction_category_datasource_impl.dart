import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_category_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_category_model.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionCategoryDatasourceImpl extends TransactionCategoryDatasource {
  final SupabaseClient supabaseClient;

  TransactionCategoryDatasourceImpl(this.supabaseClient);

  @override
  Future<List<TransactionCategoryEntity>> getCategory() async {
    try {
      final result = await supabaseClient.from('categories').select();

      return (result as List)
          .map((json) => TransactionCategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw CategoryException("check your Internet connection");
    }
  }
}
