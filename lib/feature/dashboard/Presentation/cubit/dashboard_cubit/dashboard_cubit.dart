import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_states.dart';
import 'package:expense_tracker/feature/dashboard/domain/usecase/dashboard_summary_usecases.dart';

class DashboardCubit extends Cubit<DashboardStates> {
  final DashboardSummaryUsecases dashboardSummaryUsecases;
  DashboardCubit(this.dashboardSummaryUsecases)
    : super(const DashboardInitial());

  Future<void> dashboardSummary() async {
    emit(const DashboardLoading());

    final result = await dashboardSummaryUsecases();

    result.fold(
      (failure) {
        emit(DashboardFailure(failure.message));
      },
      (summary) {
        emit(DashboardLoaded(summary));
      },
    );
  }
}
