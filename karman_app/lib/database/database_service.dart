import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:karman_app/database/habit_db.dart';
import 'package:karman_app/database/task_db.dart';
import 'package:karman_app/database/focus_db.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  static const _databaseName = "karman_app.db";
  static const _databaseVersion = 1;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<String> get fullPath async {
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, _databaseName);
  }

  Future<Database> _initializeDatabase() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      singleInstance: true,
    );
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await TaskDatabase().createTable(db);
    await HabitDatabase().createTables(db);
    await FocusDatabase().createTable(db);
    await HabitDatabase().createBadgesTable(db);
  }

  Future<void> ensureInitialized() async {
    await database;
  }

  Future<void> deleteDatabase() async {
    final path = await fullPath;
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
