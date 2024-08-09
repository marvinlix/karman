import 'package:karman_app/database/database_service.dart';
import 'package:karman_app/database/task_db.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TaskService {
  final DatabaseService _databaseService = DatabaseService();
  final TaskDatabase _taskDatabase = TaskDatabase();

  Future<Task> createTask(Task task) async {
    final db = await _databaseService.database;
    final id = await _taskDatabase.createTask(db, task.toMap());
    return task.copyWith(taskId: id);
  }

  Future<List<Task>> getTasks() async {
    final db = await _databaseService.database;
    final tasksData = await _taskDatabase.getTasks(db);
    return tasksData.map((taskData) => Task.fromMap(taskData)).toList();
  }

  Future<Task> updateTask(Task task) async {
    final db = await _databaseService.database;
    await _taskDatabase.updateTask(db, task.toMap());
    return task;
  }

  Future<void> deleteTask(int id) async {
    final db = await _databaseService.database;
    await _taskDatabase.deleteTask(db, id);
  }

  Future<void> deleteCompletedTasks() async {
    final db = await _databaseService.database;
    await _taskDatabase.deleteCompletedTasks(db);
  }

  Future<Task?> getTaskById(int id) async {
    final db = await _databaseService.database;
    final taskData = await _taskDatabase.getTaskById(db, id);
    return taskData != null ? Task.fromMap(taskData) : null;
  }

  Future<void> addInitialTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedVersion = prefs.getString('app_version');

    // Get current app version
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version;

    // Check if it's a fresh install (no stored version) or same version
    if (storedVersion == null || storedVersion == currentVersion) {
      final bool tasksAdded = prefs.getBool('initial_tasks_added') ?? false;

      if (!tasksAdded) {
        final initialTasks = [
          Task(
            name: 'Mark task as complete',
            priority: 3,
          ),
          Task(
            name: 'Create a new task (tap ⊕)',
            priority: 3,
          ),
          Task(
            name: 'Tap a task to view details',
            priority: 2,
          ),
          Task(
            name: 'Set reminder or due date',
            priority: 2,
          ),
          Task(
            name: 'Delete task (swipe left)',
            priority: 1,
          ),
          Task(
            name: 'Clear completed tasks (tap ⊗)',
            priority: 1,
          ),
        ];

        for (var task in initialTasks) {
          await createTask(task);
        }

        await prefs.setBool('initial_tasks_added', true);
      }
    }

    // Always update the stored version
    await prefs.setString('app_version', currentVersion);
  }
}
