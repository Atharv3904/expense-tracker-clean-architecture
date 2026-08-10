import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';

sealed class DashboardStates {
  const DashboardStates();
}

class DashboardInitial extends DashboardStates {
  const DashboardInitial();
}

class DashboardLoading extends DashboardStates {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardStates {
  final DashboardSummary summary;
  const DashboardLoaded(this.summary);
}

class DashboardFailure extends DashboardStates {
  final String message;
  const DashboardFailure(this.message);
}
