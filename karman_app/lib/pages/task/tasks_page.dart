import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/components/dialog_window.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/models/task/task_folder.dart';
import 'package:karman_app/pages/task/task_details_sheet.dart';
import 'package:karman_app/pages/task/task_tile.dart';
import 'package:karman_app/components/folder_drawer.dart';
import 'package:karman_app/services/notification_service.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int currentFolderId = 1; // Assuming 1 is the default folder ID

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
      context.read<TaskController>().loadFolders();
    });
  }

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _folderController = TextEditingController();

  void _addFolder() {
    final newFolder = TaskFolder(name: _folderController.text);
    context.read<TaskController>().addFolder(newFolder);
    _folderController.clear();
  }

  void _toggleTaskCompletion(Task task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    context.read<TaskController>().updateTask(updatedTask);
  }

  void _editTask(BuildContext context, Task task) {
    _taskController.text = task.name;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return KarmanDialogWindow(
          controller: _taskController,
          onSave: () {
            final updatedTask = task.copyWith(name: _taskController.text);
            context.read<TaskController>().updateTask(updatedTask);
            _taskController.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            _taskController.clear();
            Navigator.of(context).pop();
          },
          initialText: task.name,
        );
      },
    );
  }

  void _deleteTask(BuildContext context, int id) {
    context.read<TaskController>().deleteTask(id);
  }

  void _addTask() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return KarmanDialogWindow(
          controller: _taskController,
          onSave: () {
            final newTask = Task(
              name: _taskController.text,
              priority: 1,
              folderId: currentFolderId,
            );
            context.read<TaskController>().addTask(newTask);
            _taskController.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            _taskController.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _openDrawer() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return FolderDrawer(
          onFolderSelected: (folder) {
            setState(() {
              currentFolderId = folder.folder_id!;
            });
          },
          controller: _folderController,
          onCreateFolder: _addFolder,
        );
      },
    );
  }

  void _openTaskDetails(Task task) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return TaskDetailsSheet(
          task: task,
        );
      },
    );
  }

  String getAppbarTitle(List<TaskFolder> folders) {
    if (folders.isEmpty) {
      return '¯\\_(ツ)_/¯';
    } else {
      final currentFolder =
          folders.firstWhere((folder) => folder.folder_id == currentFolderId);
      return currentFolder.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        final folders = taskController.folders;
        final tasks = taskController.tasks
            .where((task) => task.folderId == currentFolderId)
            .toList();

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.black,
            middle: Text(getAppbarTitle(folders)),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _openDrawer,
              child: Icon(
                CupertinoIcons.square_stack,
                color: CupertinoColors.white,
              ),
            ),
            trailing: folders.isEmpty
                ? null
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _addTask,
                    child: Icon(
                      CupertinoIcons.plus,
                      color: CupertinoColors.white,
                    ),
                  ),
          ),
          child: SafeArea(
            child: _buildTasksList(folders, tasks),
          ),
        );
      },
    );
  }

  Widget _buildTasksList(List<TaskFolder> folders, List<Task> tasks) {
    if (folders.isEmpty) {
      return Center(
        child: Text(
          'No folders? Create one!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks yet. Add one!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onTap: () => _openTaskDetails(task),
            child: TaskTile(
              task: task,
              onChanged: (value) => _toggleTaskCompletion(task),
              onEdit: (context) => _editTask(context, task),
              onDelete: (context) => _deleteTask(context, task.task_id!),
            ),
          );
        },
      );
    }
  }
}
