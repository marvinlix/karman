import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/date_time/date_option.dart';
import 'package:karman_app/components/date_time/reminder_option.dart';

class TaskOptionsSection extends StatelessWidget {
  final bool isDateEnabled;
  final bool isReminderEnabled;
  final DateTime? dueDate;
  final DateTime? reminder;
  final Function(bool) onDateToggle;
  final Function(bool) onReminderToggle;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onReminderSet;

  const TaskOptionsSection({
    super.key,
    required this.isDateEnabled,
    required this.isReminderEnabled,
    required this.dueDate,
    required this.reminder,
    required this.onDateToggle,
    required this.onReminderToggle,
    required this.onDateSelected,
    required this.onReminderSet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateOptionWidget(
          isEnabled: isDateEnabled,
          date: dueDate,
          onToggle: onDateToggle,
          onDateSelected: onDateSelected,
          title: 'Date',
          placeholder: 'Due Date',
        ),
        SizedBox(height: 20),
        ReminderOptionWidget(
          isEnabled: isReminderEnabled,
          dateTime: reminder,
          onToggle: onReminderToggle,
          onDateTimeSelected: onReminderSet,
          title: 'Reminder',
          placeholder: 'Reminder',
        ),
      ],
    );
  }
}
