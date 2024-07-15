import 'package:flutter/foundation.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:karman_app/models/habits/habit_log.dart';
import 'package:karman_app/services/habit/habit_service.dart';

class HabitController extends ChangeNotifier {
  final HabitService _habitService = HabitService();

  List<Habit> _habits = [];
  final Map<int, List<HabitLog>> _habitLogs = {};

  List<Habit> get habits => _habits;
  Map<int, List<HabitLog>> get habitLogs => _habitLogs;

  Future<void> loadHabits() async {
    _habits = await _habitService.getHabits();
    notifyListeners();
  }

  Future<void> loadHabitLogs(int habitId) async {
    _habitLogs[habitId] = await _habitService.getHabitLogs(habitId);
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    final id = await _habitService.createHabit(habit);
    final newHabit = habit.copyWith(habitId: id);
    _habits.add(newHabit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitService.updateHabit(habit);
    final index = _habits.indexWhere((h) => h.habitId == habit.habitId);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(int? id) async {
    if (id == null) return;

    await _habitService.deleteHabit(id);
    _habits.removeWhere((habit) => habit.habitId == id);
    _habitLogs.remove(id);
    notifyListeners();
  }

  Future<void> completeHabitForToday(Habit habit, String? log) async {
    final today = DateTime.now();
    final todayLog = HabitLog(
      habitId: habit.habitId!,
      completedForToday: true,
      date: today,
      log: log,
    );

    await _habitService.createHabitLog(todayLog);

    habit.incrementStreak();
    habit.isCompletedToday = true;
    await updateHabit(habit);

    // Update local data
    _habitLogs[habit.habitId!] ??= [];
    _habitLogs[habit.habitId!]!.add(todayLog);

    notifyListeners();
  }

  Future<void> resetStreaksIfNeeded() async {
    final today = DateTime.now();
    for (var habit in _habits) {
      final logs = _habitLogs[habit.habitId] ?? [];
      final yesterdayLog = logs.lastWhere(
        (log) => log.date.difference(today).inDays == -1,
        orElse: () => HabitLog(
          habitId: habit.habitId!,
          completedForToday: false,
          date: today.subtract(Duration(days: 1)),
        ),
      );

      if (!yesterdayLog.completedForToday) {
        habit.resetStreak();
        await updateHabit(habit);
      }

      // Reset isCompletedToday for the new day
      if (habit.isCompletedToday) {
        habit.isCompletedToday = false;
        await updateHabit(habit);
      }
    }
    notifyListeners();
  }

  // Call this method when the app starts or when the date changes
  Future<void> checkAndResetStreaks() async {
    await resetStreaksIfNeeded();
    await loadHabits(); // Reload habits to get updated streak information
    notifyListeners();
  }

  Future<List<HabitLog>>? loadHabitLogsById(String habitId) async {
    final logs = await _habitService.getHabitLogs(int.parse(habitId));
    return logs;
  }
}
