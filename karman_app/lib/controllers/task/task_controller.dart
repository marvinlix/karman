import 'package:flutter/foundation.dart';
import 'package:karman_app/models/task/task.dart';
import '../../services/task/task_service.dart';
import 'dart:async';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  final Map<int, Timer> _completionTimers = {};
  final Map<int, bool> _pendingCompletions = {};
  final Map<int, Timer> _updateTimers = {};

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    await _taskService.addInitialTasks();
    _tasks = await _taskService.getTasks();
    _scheduleAllUpdates();
    notifyListeners();
  }

  Future<Task> addTask(Task task) async {
    try {
      final newTask = await _taskService.createTask(task);
      _tasks.add(newTask);
      _scheduleTaskUpdates(newTask);
      notifyListeners();
      return newTask;
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  Future<Task> updateTask(Task task) async {
    await _taskService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.taskId == task.taskId);
    if (index != -1) {
      _tasks[index] = task;
      _scheduleTaskUpdates(task);
      notifyListeners();
    }
    return task;
  }

  void toggleTaskCompletion(Task task) {
    final taskId = task.taskId!;
    if (_pendingCompletions[taskId] == true) {
      _completionTimers[taskId]?.cancel();
      _completionTimers.remove(taskId);
      _pendingCompletions[taskId] = false;
    } else if (!task.isCompleted) {
      _pendingCompletions[taskId] = true;
      _completionTimers[taskId] = Timer(Duration(seconds: 3), () {
        final updatedTask = task.copyWith(isCompleted: true);
        updateTask(updatedTask);
        _completionTimers.remove(taskId);
        _pendingCompletions.remove(taskId);
        notifyListeners();
      });
    } else {
      final updatedTask = task.copyWith(isCompleted: false);
      updateTask(updatedTask);
    }
    notifyListeners();
  }

  bool isTaskPendingCompletion(int taskId) {
    return _pendingCompletions[taskId] == true;
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    _tasks.removeWhere((task) => task.taskId == id);
    _completionTimers[id]?.cancel();
    _completionTimers.remove(id);
    _pendingCompletions.remove(id);
    _updateTimers[id]?.cancel();
    _updateTimers.remove(id);
    notifyListeners();
  }

  Future<void> clearCompletedTasks() async {
    await _taskService.deleteCompletedTasks();
    _tasks.removeWhere((task) {
      if (task.isCompleted) {
        _updateTimers[task.taskId]?.cancel();
        _updateTimers.remove(task.taskId);
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> getIncompleteTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  Future<Task?> getTaskById(int taskId) async {
    try {
      return await _taskService.getTaskById(taskId);
    } catch (e) {
      print('Error fetching task: $e');
      return null;
    }
  }

  void scheduleUpdate(int taskId, DateTime updateTime) {
    _updateTimers[taskId]?.cancel();

    final now = DateTime.now();
    final duration = updateTime.difference(now);

    if (duration.isNegative) {
      notifyListeners();
    } else {
      _updateTimers[taskId] = Timer(duration, () {
        notifyListeners();
        _updateTimers.remove(taskId);
      });
    }
  }

  void _scheduleTaskUpdates(Task task) {
    if (task.dueDate != null) {
      scheduleUpdate(task.taskId!, task.dueDate!);
    }
    if (task.reminder != null) {
      scheduleUpdate(task.taskId!, task.reminder!);
    }
  }

  void _scheduleAllUpdates() {
    for (var task in _tasks) {
      _scheduleTaskUpdates(task);
    }
  }

  @override
  void dispose() {
    for (var timer in _completionTimers.values) {
      timer.cancel();
    }
    for (var timer in _updateTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
