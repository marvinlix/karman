import 'package:karman_app/database/database_service.dart';
import 'package:karman_app/database/habit_db.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:karman_app/models/habits/habit_log.dart';

class HabitService {
  final DatabaseService _databaseService = DatabaseService();
  final HabitDatabase _habitDatabase = HabitDatabase();

  // Habit operations
  Future<int> createHabit(Habit habit) async {
    final db = await _databaseService.database;
    return await _habitDatabase.createHabit(db, habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final db = await _databaseService.database;
    final habitsData = await _habitDatabase.getHabits(db);
    return habitsData.map((habitData) => Habit.fromMap(habitData)).toList();
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await _databaseService.database;
    return await _habitDatabase.updateHabit(db, habit.toMap());
  }

  Future<int> deleteHabit(int id) async {
    final db = await _databaseService.database;
    // Delete associated logs first
    await _habitDatabase.deleteHabitLogs(db, id);
    return await _habitDatabase.deleteHabit(db, id);
  }

  // Habit log operations
  Future<int> createHabitLog(HabitLog log) async {
    final db = await _databaseService.database;
    return await _habitDatabase.createHabitLog(db, log.toMap());
  }

  Future<List<HabitLog>> getHabitLogs(int habitId) async {
    final db = await _databaseService.database;
    final logsData = await _habitDatabase.getHabitLogs(db, habitId);
    return logsData.map((logData) => HabitLog.fromMap(logData)).toList();
  }

  Future<int> updateHabitLog(HabitLog log) async {
    final db = await _databaseService.database;
    return await _habitDatabase.updateHabitLog(db, log.toMap());
  }

  Future<int> deleteHabitLog(int id) async {
    final db = await _databaseService.database;
    return await _habitDatabase.deleteHabitLog(db, id);
  }

  Future<HabitLog?> getLatestHabitLog(int habitId) async {
    final db = await _databaseService.database;
    final logData = await _habitDatabase.getLatestHabitLog(db, habitId);
    return logData != null ? HabitLog.fromMap(logData) : null;
  }

  Future<void> resetStreaksIfNeeded() async {
    final db = await _databaseService.database;
    final habits = await getHabits();
    final today = DateTime.now();

    for (var habit in habits) {
      final latestLog = await getLatestHabitLog(habit.habitId!);
      if (latestLog != null) {
        final daysSinceLastLog = today.difference(latestLog.date).inDays;
        if (daysSinceLastLog > 1 ||
            (daysSinceLastLog == 1 && !latestLog.completedForToday)) {
          habit.resetStreak();
          await updateHabit(habit);
        }
      }
    }

    // Reset isCompletedToday for all habits
    await _habitDatabase.resetAllHabitsCompletionStatus(db);
  }

  Future<void> completeHabitForToday(Habit habit, String? log) async {
    final today = DateTime.now();
    final todayLog = HabitLog(
      habitId: habit.habitId!,
      completedForToday: true,
      date: today,
      log: log,
    );

    await createHabitLog(todayLog);

    habit.incrementStreak();
    habit.isCompletedToday = true;
    await updateHabit(habit);
  }

  Future<bool> isHabitCompletedToday(int habitId) async {
    final db = await _databaseService.database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    final logs = await _habitDatabase.getHabitLogsForDate(db, habitId, today);
    return logs.isNotEmpty && logs.first['completedForToday'] == 1;
  }
}
