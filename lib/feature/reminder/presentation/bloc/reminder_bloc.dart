import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/cancel_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/clear_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/get_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/save_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/schedule_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_event.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_states.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  // Notification scheduling
  final ScheduleDailyReminderUsecase scheduleDailyReminderUsecase;
  final CancelDailyReminderUsecase cancelDailyReminderUsecase;

  // SharedPreferences
  final SaveReminderUsecase saveReminderUsecase;
  final GetReminderUsecase getReminderUsecase;
  final ClearReminderUsecase clearReminderUsecase;

  ReminderBloc({
    required this.scheduleDailyReminderUsecase,
    required this.cancelDailyReminderUsecase,
    required this.saveReminderUsecase,
    required this.getReminderUsecase,
    required this.clearReminderUsecase,
  }) : super(const ReminderInitial()) {
    on<LoadReminder>(_loadReminder);
    on<ScheduleReminder>(_scheduleReminder);
    on<CancelReminder>(_cancelReminder);
  }

  Future<void> _loadReminder(
    LoadReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());

    try {
      final reminder = await getReminderUsecase();

      if (reminder == null) {
        emit(
          ReminderLoaded(
            ReminderEntity(dailyEnabled: false, hour: 20, minute: 0),
          ),
        );
      } else {
        emit(ReminderLoaded(reminder));
      }
    } catch (e) {
      emit(ReminderFailure(e.toString()));
    }
  }

  Future<void> _scheduleReminder(
    ScheduleReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());

    // 1. Schedule local notification
    final result = await scheduleDailyReminderUsecase(event.reminder);

    await result.fold(
      (failure) async {
        emit(ReminderFailure(failure.message));
      },
      (_) async {
        try {
          // 2. Save reminder settings in SharedPreferences
          await saveReminderUsecase(event.reminder);

          emit(const ReminderSuccess());
        } catch (e) {
          emit(ReminderFailure(e.toString()));
        }
      },
    );
  }

  Future<void> _cancelReminder(
    CancelReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());

    // 1. Cancel local notification
    final result = await cancelDailyReminderUsecase();

    await result.fold(
      (failure) async {
        emit(ReminderFailure(failure.message));
      },
      (_) async {
        try {
          // 2. Clear SharedPreferences
          await clearReminderUsecase();

          emit(const ReminderCancel());
        } catch (e) {
          emit(ReminderFailure(e.toString()));
        }
      },
    );
  }
}
