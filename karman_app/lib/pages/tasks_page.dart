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
  final _myBox = Hive.box('myBox');
  KarmanDataBase db = KarmanDataBase();

  @override
  void initState() {
    if (_myBox.get('tasks') == null) {
      db.createIntialData();
      db.updateDataBase();
    } else {
      db.loadData();
    }
    super.initState();
    db.loadData();
  }

  final _controller = TextEditingController();

  void saveNewTask() {
    setState(() {
      db.taskList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.taskList[index][1] = !db.taskList[index][1];
    });
    db.updateDataBase();
  }

  void editTask(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: () {
            setState(() {
              db.taskList[index][0] = _controller.text;
              _controller.clear();
            });
            Navigator.of(context).pop();
            db.updateDataBase();
          },
        );
      },
    );
    _controller.text = db.taskList[index][0];
  }

  void deleteTask(int index, BuildContext context) {
    setState(() {
      db.taskList.removeAt(index);
    });
    db.updateDataBase();
  }

  void createNewTask() {
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
              key: ValueKey(db.taskList[index]),
              taskName: db.taskList[index][0],
              taskCompleted: db.taskList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              onEdit: (context) => editTask(context, index),
              onDelete: (context) => deleteTask(index, context),
            );
          },
          proxyDecorator: (widget, index, animation) {
            return Transform.scale(
              scale: 1.03,
              child: Material(
                color: Colors.black,
                elevation: 0,
                child: widget,
              ),
            );
          },
        ),
      ),
    );
  }
}
