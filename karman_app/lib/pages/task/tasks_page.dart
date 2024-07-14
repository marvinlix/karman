import 'package:flutter/cupertino.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/pages/task/task_details_sheet.dart';
import 'package:karman_app/components/task/task_tile.dart';
import 'package:karman_app/components/task/completed_task_header.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _sortedTasks = [];

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

  void _clearCompletedTasks(List<Task> completedTasks) {
    for (var task in completedTasks) {
      _deleteTask(context, task.taskId!);
    }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        _sortTasks(taskController.tasks);

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _addTask,
              child: Icon(
                CupertinoIcons.plus,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                CompletedTasksHeader(
                  onClearCompletedTasks: _clearCompletedTasks,
                ),
                Expanded(
                  child: _buildTasksList(_sortedTasks),
                ),
              ],
            ),
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
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onTap: () => _openTaskDetails(task),
            child: TaskTile(
              key: ValueKey(task.taskId),
              task: task,
              onChanged: (value) => _toggleTaskCompletion(task),
              onEdit: (context) => _openTaskDetails(task),
              onDelete: (context) => _deleteTask(context, task.taskId!),
            ),
          );
        },
      );
    }
  }
}
