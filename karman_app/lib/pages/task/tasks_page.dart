import 'package:flutter/cupertino.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/pages/task/task_details_sheet.dart';
import 'package:karman_app/components/task/taskPageWidgets/task_list.dart';
import 'package:karman_app/pages/tutorial/task_tutorial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  List<Task> _sortedTasks = [];
  final Map<int, bool> _expandedSections = {1: true, 2: true, 3: true, 0: true};
  bool _showTutorial = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
      _checkFirstLaunch();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (isFirstLaunch) {
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        _showTutorial = true;
      });
      _animationController.forward();
    }
  }

  void _onTutorialComplete() async {
    await _animationController.reverse();
    setState(() {
      _showTutorial = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }

  void _sortTasks(List<Task> tasks, TaskController taskController) {
    _sortedTasks = List.from(tasks);
    _sortedTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return tasks.indexOf(a).compareTo(tasks.indexOf(b));
    });
  }

  void _toggleTaskCompletion(Task task) {
    context.read<TaskController>().toggleTaskCompletion(task);
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
        _sortTasks(context.read<TaskController>().tasks,
            context.read<TaskController>());
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
        title: Text('Clear Completed Tasks?'),
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
        _sortTasks(taskController.tasks, taskController);
        final incompleteTasks = _sortedTasks
            .where((task) =>
                !task.isCompleted &&
                !taskController.isTaskPendingCompletion(task.taskId!))
            .length;
        final hasCompletedTasks = _sortedTasks.any((task) => task.isCompleted);

        return Stack(
          children: [
            CupertinoPageScaffold(
              backgroundColor: CupertinoColors.black,
              navigationBar: CupertinoNavigationBar(
                backgroundColor: CupertinoColors.black,
                border: null,
                leading: CupertinoButton(
                  onPressed: hasCompletedTasks ? _clearCompletedTasks : null,
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: hasCompletedTasks
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey,
                    size: 32,
                  ),
                ),
                middle: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    incompleteTasks == 0
                        ? 'No tasks left'
                        : '$incompleteTasks task${incompleteTasks == 1 ? '' : 's'} left',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                trailing: CupertinoButton(
                  onPressed: _addTask,
                  child: Icon(
                    CupertinoIcons.plus_circle,
                    color: CupertinoColors.white,
                    size: 32,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SafeArea(
                  child: TaskList(
                    tasks: _sortedTasks,
                    expandedSections: _expandedSections,
                    onToggleSection: _toggleSection,
                    onTaskToggle: _toggleTaskCompletion,
                    onTaskDelete: _deleteTask,
                    onTaskTap: _openTaskDetails,
                  ),
                ),
              ),
            ),
            if (_showTutorial)
              FadeTransition(
                opacity: _fadeAnimation,
                child: TasksTutorial.build(context, _onTutorialComplete),
              ),
          ],
        );
      },
    );
  }
}
