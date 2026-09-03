import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/cancel_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/schedule_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_event.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_states.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ScheduleDailyReminderUsecase scheduleDailyReminderUsecase;
  final CancelDailyReminderUsecase cancelDailyReminderUsecase;

  ReminderBloc({
    required this.scheduleDailyReminderUsecase,
    required this.cancelDailyReminderUsecase,
  }) : super(const ReminderInitial()) {
    on<ScheduleReminder>(_scheduleDailyReminder);
    on<CancelReminder>(_cancelDailyReminder);
  }

  Future<void> _scheduleDailyReminder(
    ScheduleReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    final result = await scheduleDailyReminderUsecase(event.reminder);

    result.fold(
      (failure) {
        emit(ReminderFailure(failure.message));
      },
      (_) {
        emit(const ReminderSuccess());
      },
    );
  }

  Future<void> _cancelDailyReminder(
    CancelReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    final result = await cancelDailyReminderUsecase();

    result.fold(
      (failure) {
        emit(ReminderFailure(failure.message));
      },
      (_) {
        emit(const ReminderCancel());
      },
    );
  }
}
