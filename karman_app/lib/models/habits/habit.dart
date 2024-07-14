import 'package:flutter/cupertino.dart';

class Habit {
  final int? habitId;
  final String name;
  final bool status;
  final DateTime startDate;
  final DateTime? endDate;
  final int currentStreak;
  final int longestStreak;
  final IconData? icon;

  Habit({
    this.habitId,
    required this.name,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.currentStreak,
    required this.longestStreak,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'name': name,
      'status': status ? 1 : 0,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'icon': icon?.codePoint,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      habitId: map['habitId'],
      name: map['name'],
      status: map['status'] == 1,
      startDate: DateTime.parse(map['start_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      currentStreak: map['current_streak'],
      longestStreak: map['longest_streak'],
      icon: map['icon'] != null
          ? IconData(map['icon'], fontFamily: 'CupertinoIcons')
          : null,
    );
  }

  Habit copyWith({
    int? habitId,
    String? name,
    bool? status,
    DateTime? startDate,
    DateTime? endDate,
    int? currentStreak,
    int? longestStreak,
    IconData? icon,
  }) {
    return Habit(
      habitId: habitId ?? this.habitId,
      name: name ?? this.name,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      icon: icon ?? this.icon,
    );
  }
}
