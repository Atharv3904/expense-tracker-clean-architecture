abstract class ReminderState {
  const ReminderState();
}

class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

class ReminderSuccess extends ReminderState {
  const ReminderSuccess();
}

class ReminderFailure extends ReminderState {
  final String message;

  const ReminderFailure(this.message);
}

class ReminderCancel extends ReminderState {
  const ReminderCancel();
}
