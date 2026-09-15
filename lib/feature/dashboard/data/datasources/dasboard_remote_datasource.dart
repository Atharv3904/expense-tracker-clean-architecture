import 'package:expense_tracker/feature/dashboard/data/model/dashboard_summary_model.dart';

abstract class DasboardDatasource {
  Future<DashboardSummaryModel> getDashboardSummary();
}
