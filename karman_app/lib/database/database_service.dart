import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:karman_app/database/habit_db.dart';
import 'package:karman_app/database/task_db.dart';
import 'package:karman_app/database/focus_db.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<String> get fullPath async {
    const databaseName = 'karman.db';
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, databaseName);
  }

  Future<Database> _initializeDatabase() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 3, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      singleInstance: true,
    );
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await TaskDatabase().createTable(db);
    await HabitDatabase().createTables(db);
    await FocusDatabase().createTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await FocusDatabase().createTable(db);
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${FocusDatabase().badgesTableName} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          badge_name TEXT NOT NULL,
          achieved_date TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> ensureInitialized() async {
    await database;
  }
}
