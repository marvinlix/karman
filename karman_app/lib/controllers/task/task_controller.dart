import 'package:flutter/foundation.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/models/task/task_folder.dart';
import '../../services/task/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  List<TaskFolder> _folders = [];

  List<Task> get tasks => _tasks;
  List<TaskFolder> get folders => _folders;

  Future<void> loadTasks() async {
    _tasks = await _taskService.getTasks();
    notifyListeners();
  }

  Future<void> loadFolders() async {
    _folders = await _taskService.getFolders();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await _taskService.createTask(task);
    final newTask = Task(
      task_id: id,
      name: task.name,
      note: task.note,
      priority: task.priority,
      dueDate: task.dueDate,
      reminder: task.reminder,
      folderId: task.folderId,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _taskService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.task_id == task.task_id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    _tasks.removeWhere((task) => task.task_id == id);
    notifyListeners();
  }

  Future<void> addFolder(TaskFolder folder) async {
    final id = await _taskService.createFolder(folder);
    final newFolder = TaskFolder(folder_id: id, name: folder.name);
    _folders.add(newFolder);
    notifyListeners();
  }

  Future<void> updateFolder(TaskFolder folder) async {
    await _taskService.updateFolder(folder);
    final index = _folders.indexWhere((f) => f.folder_id == folder.folder_id);
    if (index != -1) {
      _folders[index] = folder;
      notifyListeners();
    }
  }

  Future<void> deleteFolder(int id) async {
    await _taskService.deleteFolder(id);
    _folders.removeWhere((folder) => folder.folder_id == id);
    notifyListeners();
  }
}
