import 'package:sqflite/sqflite.dart';

class HabitDatabase {
  final String tableName = 'habits';
  final String logTableName = 'habit_logs';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        habitId INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        status INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        current_streak INTEGER NOT NULL,
        longest_streak INTEGER NOT NULL,
        icon INTEGER
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $logTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        status INTEGER NOT NULL,
        FOREIGN KEY (habitId) REFERENCES $tableName (habitId),
        UNIQUE (habitId, date)
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
}
