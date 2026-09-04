import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';
import 'package:expense_tracker/feature/dashboard/domain/repository/dashboard_repository.dart';

class DashboardSummaryUsecases {
  final DashboardRepository repository;
  DashboardSummaryUsecases(this.repository);
  AppResult<DashboardSummary> call() async {
    return await repository.getDashboardSummary();
  }
}
