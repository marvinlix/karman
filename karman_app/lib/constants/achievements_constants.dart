// lib/constants/achievement_constants.dart

class AchievementConstants {
  static const List<Achievement> achievements = [
    Achievement("Minute Master",
        "Complete 30 minutes of focused activity in a single day."),
    Achievement("Half-Hour Hero",
        "Complete 60 minutes of focused activity in a single day."),
    Achievement("Productivity Pro",
        "Complete 90 minutes of focused activity in a single day."),
    Achievement("Centurion",
        "Complete 100 minutes of focused activity in a single day."),
    Achievement("Two-Hour Triumph",
        "Complete 120 minutes of focused activity in a single day."),
    Achievement("Daily Dynamo",
        "Complete a total of 150 minutes of focused activity in a single day."),
    Achievement("Focus Fiend",
        "Complete 30 minutes of focused activity every day for 3 consecutive days."),
    Achievement("Consistency Champion",
        "Complete 60 minutes of focused activity every day for 7 consecutive days."),
    Achievement("Weekly Warrior",
        "Complete 90 minutes of focused activity every day for 7 consecutive days."),
    Achievement("Monthly Milestone",
        "Average 60 minutes of focused activity per day for a full month (30 days)."),
    Achievement("Focus Fanatic",
        "Complete 150 minutes of focused work in a single day."),
    Achievement("Steady Stream",
        "Complete 180 minutes of focused work in a single day."),
    Achievement("Daily Dedication",
        "Accumulate 60 minutes of focused work daily for 5 consecutive days."),
    Achievement("Extended Effort",
        "Accumulate 120 minutes of focused work daily for 7 consecutive days."),
    Achievement("Two-Hour Triumph",
        "Complete 120 minutes of focused work in a single day, and 3 days in a row."),
    Achievement("Weekly Winner",
        "Complete a total of 600 minutes of focused work in a week."),
    Achievement("Focused Finder",
        "Complete 90 minutes of focused work every day for 10 consecutive days."),
    Achievement("Monthly Marathoner",
        "Accumulate 1200 minutes of focused work in a month."),
    Achievement("Routine Regulator",
        "Accumulate 90 minutes of focused work every day for 30 days."),
    Achievement("Ultimate Timer",
        "Complete a total of 5000 minutes of focused work over 3 months."),
  ];
}

class Achievement {
  final String name;
  final String description;

  const Achievement(this.name, this.description);
}
