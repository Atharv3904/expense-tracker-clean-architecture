class ReminderEntity {
  final bool dailyEnabled;
  final int hour;
  final int minute;

  ReminderEntity({
    required this.dailyEnabled,
    required this.hour,
    required this.minute,
  });
} //it represents whats the user wants to be reminded about, and when. It is used to create a reminder notification for the user
