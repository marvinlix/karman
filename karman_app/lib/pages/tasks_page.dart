import 'package:flutter/material.dart';
import 'package:karman_app/components/side_drawer.dart';
import 'package:karman_app/components/task_dialog.dart';
import 'package:karman_app/components/task_tile.dart';
import 'package:karman_app/data/database.dart';

class TasksPage extends StatefulWidget {
  final String folderName;
  final KarmanDataBase db;

  const TasksPage({super.key, required this.folderName, required this.db});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List taskList = [];

  @override
  void initState() {
    super.initState();
    widget.db.loadData();
    taskList = widget.db.folders[widget.folderName] ?? [];
  }

  final _controller = TextEditingController();

  void saveNewTask() {
    setState(() {
      taskList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    widget.db.updateDatabase();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      taskList[index][1] = !taskList[index][1];
    });
    widget.db.updateDatabase();
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
              taskList[index][0] = _controller.text;
              _controller.clear();
            });
            Navigator.of(context).pop();
            widget.db.updateDatabase();
          },
        );
      },
    );
    _controller.text = taskList[index][0];
  }

  void deleteTask(int index, BuildContext context) {
    setState(() {
      taskList.removeAt(index);
    });
    widget.db.updateDatabase();
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
      final item = taskList.removeAt(oldIndex);
      taskList.insert(newIndex, item);
    });
    widget.db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            '${widget.folderName} Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: SideDrawer(
          onFolderSelected: (folder) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TasksPage(folderName: folder, db: widget.db),
              ),
            );
          },
          db: widget.db,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: createNewTask,
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            elevation: 0,
            enableFeedback: true,
            child: Icon(
              Icons.add_rounded,
              color: Colors.black,
              size: 32,
            ),
          ),
        ),
        body: ReorderableListView.builder(
          onReorder: reorderTasks,
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return TaskTile(
              key: ValueKey(taskList[index]),
              taskName: taskList[index][0],
              taskCompleted: taskList[index][1],
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
