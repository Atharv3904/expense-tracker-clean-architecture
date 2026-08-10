import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  DashboardSummaryModel({
    required super.totalExpense,
    required super.totalIncome,
    required super.balance,
  });
}
