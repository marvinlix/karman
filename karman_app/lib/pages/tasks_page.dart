import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:karman_app/components/task_dialog.dart';
import 'package:karman_app/components/task_tile.dart';
import 'package:karman_app/data/database.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Reference hive box
  final _myBox = Hive.box('myBox');

  // Instantiation of database
  KarmanDataBase db = KarmanDataBase();

  // initState to load data from the database
  @override
  void initState() {
    // if first time opening the app, create initial data
    if (_myBox.get('tasks') == null) {
      db.createIntialData();
      db.updateDataBase();
    } else {
      // there are tasks in the database, load them
      db.loadData();
    }
    super.initState();
    db.loadData();
  }

  // TextEditingController to get user input
  final _controller = TextEditingController();

  void saveNewTask() {
    setState(() {
      db.taskList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // Function to change the state of the checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.taskList[index][1] = !db.taskList[index][1];
    });
    db.updateDataBase();
  }

  // Function to edit a task
  void editTask(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: () {
            setState(() {
              // Update the task name in Hive
              db.taskList[index][0] = _controller.text;
              // Clear the controller
              _controller.clear();
            });
            Navigator.of(context).pop();
            db.updateDataBase();
          },
        );
      },
    );
    // Set the initial text of the controller to the current task name
    _controller.text = db.taskList[index][0];
  }

  // Function to delete a task
  void deleteTask(int index, BuildContext context) {
    setState(() {
      db.taskList.removeAt(index);
    });
    db.updateDataBase();
  }

  // Function to create a new task
  void createNewTask() {
    // clear the controller before opening the dialog
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveNewTask,
        );
      },
    );
  }

  // Function to reorder tasks
  void reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = db.taskList.removeAt(oldIndex);
      db.taskList.insert(newIndex, item);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'Your Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          backgroundColor: Colors.white,
          shape: CircleBorder(),
          child: Icon(
            Icons.add_rounded,
            color: Colors.black,
            size: 32,
          ),
        ),
        body: ReorderableListView.builder(
          onReorder: reorderTasks,
          itemCount: db.taskList.length,
          itemBuilder: (context, index) {
            return TaskTile(
              key: ValueKey(
                  db.taskList[index]), // Key is required for reordering
              taskName: db.taskList[index][0],
              taskCompleted: db.taskList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              onEdit: (context) => editTask(context, index),
              onDelete: (context) => deleteTask(index, context),
            );
          },
          proxyDecorator: (widget, index, animation) {
            return Material(
              color: Colors.transparent,
              child: widget,
            );
          },
        ),
      ),
    );
  }
}
