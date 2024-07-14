import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/pages/task/task_details_sheet.dart';
import 'package:karman_app/components/task/task_tile.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _sortedTasks = [];
  final Map<int, bool> _expandedSections = {
    1: true,
    2: true,
    3: true,
    0: true
  }; // Use 0 for completed tasks

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  void _sortTasks(List<Task> tasks) {
    _sortedTasks = List.from(tasks);
    _sortedTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.priority.compareTo(a.priority);
    });
  }

  void _toggleTaskCompletion(Task task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    context.read<TaskController>().updateTask(updatedTask);
    setState(() {
      _sortTasks(context.read<TaskController>().tasks);
    });
  }

  void _deleteTask(BuildContext context, int id) {
    context.read<TaskController>().deleteTask(id);
  }

  void _addTask() {
    _openTaskDetails(null);
  }

  void _openTaskDetails(Task? task) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return TaskDetailsSheet(
          task: task,
          isNewTask: task == null,
        );
      },
    ).then((_) {
      setState(() {
        _sortTasks(context.read<TaskController>().tasks);
      });
    });
  }

  void _toggleSection(int priority) {
    setState(() {
      _expandedSections[priority] = !_expandedSections[priority]!;
    });
  }

  void _clearCompletedTasks() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Clear Completed Tasks'),
        content: Text('Are you sure you want to delete all completed tasks?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TaskController>().clearCompletedTasks();
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        _sortTasks(taskController.tasks);
        final incompleteTasks =
            _sortedTasks.where((task) => !task.isCompleted).length;
        final hasCompletedTasks = _sortedTasks.any((task) => task.isCompleted);

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            border: null,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: hasCompletedTasks ? _clearCompletedTasks : null,
              child: Icon(
                CupertinoIcons.bin_xmark_fill,
                color: hasCompletedTasks
                    ? CupertinoColors.white
                    : CupertinoColors.systemGrey,
                size: 20,
              ),
            ),
            middle: Text(
              '$incompleteTasks tasks left',
              style: TextStyle(color: CupertinoColors.white),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _addTask,
              child: Icon(
                CupertinoIcons.plus_circle_fill,
                color: CupertinoColors.white,
                size: 22,
              ),
            ),
          ),
          child: SafeArea(
            child: _buildTasksList(_sortedTasks),
          ),
        );
      },
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'This space craves your brilliant ideas. Add one!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView(
        children: [
          _buildPrioritySection(3, tasks),
          _buildPrioritySection(2, tasks),
          _buildPrioritySection(1, tasks),
          _buildCompletedSection(tasks),
        ],
      );
    }
  }

  Widget _buildPrioritySection(int priority, List<Task> allTasks) {
    final tasksInPriority = allTasks
        .where((task) => task.priority == priority && !task.isCompleted)
        .toList();

    if (tasksInPriority.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _toggleSection(priority),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: CupertinoColors.black,
            child: Row(
              children: [
                Icon(
                  _expandedSections[priority]!
                      ? CupertinoIcons.flag_circle
                      : CupertinoIcons.flag_circle_fill,
                  color: priority == 3
                      ? Colors.red
                      : (priority == 2 ? Colors.yellow : Colors.green),
                ),
                SizedBox(width: 10),
                Text(
                  priority == 3 ? 'High' : (priority == 2 ? 'Medium' : 'Low'),
                  style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  _expandedSections[priority]!
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: CupertinoColors.white,
                ),
              ],
            ),
          ),
        ),
        if (_expandedSections[priority]!)
          ...tasksInPriority.map(
            (task) => GestureDetector(
              onTap: () => _openTaskDetails(task),
              child: TaskTile(
                key: ValueKey(task.taskId),
                task: task,
                onChanged: (value) => _toggleTaskCompletion(task),
                onDelete: (context) => _deleteTask(context, task.taskId!),
              ),
            ),
          ),
        SizedBox(height: 40), // Add vertical space between sections
      ],
    );
  }

  Widget _buildCompletedSection(List<Task> allTasks) {
    final completedTasks = allTasks.where((task) => task.isCompleted).toList();

    if (completedTasks.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _toggleSection(0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: CupertinoColors.black,
            child: Row(
              children: [
                Icon(
                  _expandedSections[0]!
                      ? CupertinoIcons.checkmark_circle
                      : CupertinoIcons.checkmark_circle_fill,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(width: 10),
                Text(
                  'Completed',
                  style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  _expandedSections[0]!
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: CupertinoColors.white,
                ),
              ],
            ),
          ),
        ),
        if (_expandedSections[0]!)
          ...completedTasks.map(
            (task) => GestureDetector(
              onTap: () => _openTaskDetails(task),
              child: TaskTile(
                key: ValueKey(task.taskId),
                task: task,
                onChanged: (value) => _toggleTaskCompletion(task),
                onDelete: (context) => _deleteTask(context, task.taskId!),
              ),
            ),
          ),
      ],
    );
  }
}
