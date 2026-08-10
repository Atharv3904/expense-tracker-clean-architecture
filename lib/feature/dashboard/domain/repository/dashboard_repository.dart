import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<Either<AppFailure, DashboardSummary>> getDashboardSummary();
}
