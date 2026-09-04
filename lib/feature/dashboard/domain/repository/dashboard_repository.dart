import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';

abstract class DashboardRepository {
  AppResult<DashboardSummary> getDashboardSummary();
}
