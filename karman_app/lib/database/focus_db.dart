import 'package:sqflite/sqflite.dart';

class FocusDatabase {
  final String tableName = 'focus_sessions';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        duration INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> addFocusSession(Database db, int duration, String date) async {
    return await db.insert(tableName, {
      'duration': duration,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getFocusSessionsForDate(
      Database db, String date) async {
    return await db.query(
      tableName,
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getFocusSessionsForDateRange(
      Database db, String startDate, String endDate) async {
    return await db.query(
      tableName,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
  }
}
