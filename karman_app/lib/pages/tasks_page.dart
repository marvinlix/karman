import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/components/dialog_window.dart';
import 'package:karman_app/components/task_tile.dart';
import 'package:karman_app/components/folder_drawer.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String currentFolder = 'Default';
  List<String> folders = ['Default'];
  Map<String, List<Map<String, dynamic>>> folderTasks = {
    'Default': [
      {'name': 'Task 1', 'completed': false},
      {'name': 'Task 2', 'completed': true},
    ],
  };

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _folderController = TextEditingController();

  void _toggleTaskCompletion(int index, bool? value) {
    setState(() {
      folderTasks[currentFolder]![index]['completed'] = value!;
    });
  }

  void _editTask(BuildContext context, int index) {
    _taskController.text = folderTasks[currentFolder]![index]['name'];
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: _taskController,
          onSave: () {
            setState(() {
              folderTasks[currentFolder]![index]['name'] = _taskController.text;
              _taskController.clear();
            });
            Navigator.of(context).pop();
          },
          onCancel: () {
            _taskController.clear();
            Navigator.of(context).pop();
          },
          initialText: folderTasks[currentFolder]![index]['name'],
        );
      },
    );
  }

  void _deleteTask(BuildContext context, int index) {
    setState(() {
      folderTasks[currentFolder]!.removeAt(index);
    });
  }

  void _addTask() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: _taskController,
          onSave: () {
            setState(() {
              folderTasks[currentFolder]!
                  .add({'name': _taskController.text, 'completed': false});
              _taskController.clear();
            });
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

  void _addFolder() {
    setState(() {
      folders.add(_folderController.text);
      folderTasks[_folderController.text] = [];
      _folderController.clear();
    });
  }

  void _openDrawer() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return FolderDrawer(
          folders: folders,
          onFolderSelected: (folder) {
            setState(() {
              currentFolder = folder;
            });
          },
          controller: _folderController,
          onCreateFolder: _addFolder,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        middle: Text(currentFolder),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.square_stack,
            color: CupertinoColors.white,
          ),
          onPressed: _openDrawer,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.plus,
            color: CupertinoColors.white,
          ),
          onPressed: _addTask,
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: folderTasks[currentFolder]!.length,
          itemBuilder: (context, index) {
            return TaskTile(
              taskName: folderTasks[currentFolder]![index]['name'],
              taskCompleted: folderTasks[currentFolder]![index]['completed'],
              onChanged: (value) => _toggleTaskCompletion(index, value),
              onEdit: (context) => _editTask(context, index),
              onDelete: (context) => _deleteTask(context, index),
            );
          },
        ),
      ),
    );
  }
}
