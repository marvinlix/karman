import 'package:sqflite/sqflite.dart';

class HabitDatabase {
  final String tableName = 'habits';
  final String logTableName = 'habit_logs';

  Future<void> createTables(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        habitId INTEGER PRIMARY KEY AUTOINCREMENT,
        habitName TEXT NOT NULL,
        reminderTime INTEGER,
        currentStreak INTEGER NOT NULL,
        bestStreak INTEGER NOT NULL,
        isCompletedToday INTEGER NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $logTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        completedForToday INTEGER NOT NULL,
        log TEXT,
        FOREIGN KEY (habitId) REFERENCES $tableName (habitId)
      )
    ''');
  }

  // CRUD operations for habits
  Future<int> createHabit(Database db, Map<String, dynamic> habit) async {
    return await db.insert(tableName, habit);
  }

  Future<List<Map<String, dynamic>>> getHabits(Database db) async {
    return await db.query(tableName);
  }

  Future<int> updateHabit(Database db, Map<String, dynamic> habit) async {
    return await db.update(
      tableName,
      habit,
      where: 'habitId = ?',
      whereArgs: [habit['habitId']],
    );
  }

  Future<int> deleteHabit(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'habitId = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for habit logs
  Future<int> createHabitLog(Database db, Map<String, dynamic> log) async {
    return await db.insert(logTableName, log);
  }

  Future<List<Map<String, dynamic>>> getHabitLogs(
      Database db, int habitId) async {
    return await db.query(
      logTableName,
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
  }

  Future<int> updateHabitLog(Database db, Map<String, dynamic> log) async {
    return await db.update(
      logTableName,
      log,
      where: 'id = ?',
      whereArgs: [log['id']],
    );
  }

  Future<int> deleteHabitLog(Database db, int id) async {
    return await db.delete(
      logTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHabitLogs(Database db, int habitId) async {
    return await db.delete(
      logTableName,
      where: 'habitId = ?',
      whereArgs: [habitId],
    );
  }

  Future<Map<String, dynamic>?> getLatestHabitLog(
      Database db, int habitId) async {
    final logs = await db.query(
      logTableName,
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
      limit: 1,
    );
    return logs.isNotEmpty ? logs.first : null;
  }

  Future<List<Map<String, dynamic>>> getHabitLogsForDate(
      Database db, int habitId, String date) async {
    return await db.query(
      logTableName,
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date],
    );
  }

  Future<int> resetAllHabitsCompletionStatus(Database db) async {
    return await db.update(
      tableName,
      {'isCompletedToday': 0},
    );
  }
}
