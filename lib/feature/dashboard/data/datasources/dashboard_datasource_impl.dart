import 'package:expense_tracker/feature/dashboard/data/datasources/dasboard_datasource.dart';
import 'package:expense_tracker/feature/dashboard/data/model/dashboard_summary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardDatasourceImpl implements DasboardDatasource {
  final SupabaseClient supabaseClient;

  const DashboardDatasourceImpl(this.supabaseClient);

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    final userId = supabaseClient.auth.currentUser!.id;

    try {
      // Get transaction types
      final typeResponse = await supabaseClient
          .from('transaction_types')
          .select('id, type');

      // Get user's transactions
      final transactionResponse = await supabaseClient
          .from('transactions')
          .select('amount, type_id')
          .eq('user_id', userId);

      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in transactionResponse) {
        final amount = (transaction['amount'] as num).toDouble();
        final typeId = transaction['type_id'];

        final type = typeResponse.firstWhere((type) => type['id'] == typeId);

        if (type['type'] == 'income') {
          totalIncome += amount;
        } else if (type['type'] == 'expense') {
          totalExpense += amount;
        }
      }

      final balance = totalIncome - totalExpense;

      return DashboardSummaryModel(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      );
    } catch (e) {
      throw Exception('Failed to get dashboard summary');
    }
  }
}
