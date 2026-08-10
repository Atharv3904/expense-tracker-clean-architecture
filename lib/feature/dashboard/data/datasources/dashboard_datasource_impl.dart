import 'package:expense_tracker/feature/dashboard/data/datasources/dasboard_datasource.dart';
import 'package:expense_tracker/feature/dashboard/data/model/dashboard_summary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardDatasourceImpl implements DasboardDatasource {
  final SupabaseClient supabaseClient;
  const DashboardDatasourceImpl(this.supabaseClient);
  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    //transection table will connected here
    // after US-5 Transaction is implemented.

    return DashboardSummaryModel(totalIncome: 0, totalExpense: 0, balance: 0);
  }
}
