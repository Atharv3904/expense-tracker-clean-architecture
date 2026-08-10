import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';
import 'package:expense_tracker/feature/dashboard/domain/repository/dashboard_repository.dart';

class DashboardSummaryUsecases {
  final DashboardRepository repository;
  DashboardSummaryUsecases(this.repository);
  Future<Either<AppFailure, DashboardSummary>> call() async {
    return await repository.getDashboardSummary();
  }
}
