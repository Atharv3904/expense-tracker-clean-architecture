import 'package:expense_tracker/feature/reminder/domain/entity/reminder_entity.dart';

abstract class ReminderState {
  const ReminderState();
}

/// Initial state.
class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

/// Loading while reading/saving/scheduling/cancelling.
class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

/// Reminder successfully loaded from SharedPreferences.
class ReminderLoaded extends ReminderState {
  final ReminderEntity reminder;

  const ReminderLoaded(this.reminder);
}

/// Reminder successfully scheduled and saved.
class ReminderSuccess extends ReminderState {
  const ReminderSuccess();
}

/// Reminder successfully cancelled and cleared.
class ReminderCancel extends ReminderState {
  const ReminderCancel();
}

/// Something went wrong.
class ReminderFailure extends ReminderState {
  final String message;

  const ReminderFailure(this.message);
}
