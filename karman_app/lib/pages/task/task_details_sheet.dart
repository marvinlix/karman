import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/task/taskDetailsWidgets/task_name_input.dart';
import 'package:karman_app/components/task/taskDetailsWidgets/task_options_section.dart';
import 'package:karman_app/components/task/taskDetailsWidgets/priority_selector.dart';
import 'package:karman_app/components/task/taskDetailsWidgets/task_note.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/services/notification_service.dart';
import 'package:provider/provider.dart';

class TaskDetailsSheet extends StatefulWidget {
  final Task? task;
  final bool isNewTask;

  const TaskDetailsSheet({
    super.key,
    this.task,
    required this.isNewTask,
  });

  @override
  _TaskDetailsSheetState createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  late DateTime? _dueDate;
  late int _priority;
  late DateTime? _reminder;
  bool _isDateEnabled = false;
  bool _isReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _noteController = TextEditingController(text: widget.task?.note ?? '');
    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? 1;
    _reminder = widget.task?.reminder;
    _isDateEnabled = widget.task?.dueDate != null;
    _isReminderEnabled = widget.task?.reminder != null;

    if (widget.isNewTask) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  final FocusNode _nameFocusNode = FocusNode();

  void _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      _showQuirkyDialog(
          'A Task Without a Name?', 'Please give your task a name!');
      return;
    }

    final now = DateTime.now();
    bool isPastDueDate =
        _isDateEnabled && _dueDate != null && _dueDate!.isBefore(now);
    bool isPastReminder =
        _isReminderEnabled && _reminder != null && _reminder!.isBefore(now);

    if (isPastDueDate || isPastReminder) {
      _showPastDateReminderDialog(isPastDueDate, isPastReminder);
      return;
    }

    final updatedTask = Task(
      taskId: widget.task?.taskId,
      name: _nameController.text.trim(),
      note: _noteController.text,
      priority: _priority,
      dueDate: _isDateEnabled ? _dueDate : null,
      reminder: _isReminderEnabled ? _reminder : null,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    Task savedTask;
    try {
      if (widget.isNewTask) {
        savedTask = await context.read<TaskController>().addTask(updatedTask);
      } else {
        savedTask =
            await context.read<TaskController>().updateTask(updatedTask);
      }

      if (savedTask.reminder != null && savedTask.taskId != null) {
        await NotificationService.scheduleNotification(
          id: savedTask.taskId!,
          title: 'Task Reminder',
          body: savedTask.name,
          scheduledDate: savedTask.reminder!,
          payload: 'task_${savedTask.taskId}',
        );
      } else if (savedTask.taskId != null) {
        await NotificationService.cancelNotification(savedTask.taskId!);
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving task: $e');
      _showQuirkyDialog('Oops! Something Went Wrong',
          'The task gremlins are acting up. Please try again later.');
    }
  }

  void _showQuirkyDialog(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title, style: TextStyle(fontSize: 18)),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text('Got it!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPastDateReminderDialog(bool isPastDueDate, bool isPastReminder) {
    String title = 'Time Travel Alert!';
    String content = '';

    if (isPastDueDate && isPastReminder) {
      content =
          'The due date and reminder are set in the past. Please update them or turn them off to save the changes.';
    } else if (isPastDueDate) {
      content =
          'The due date is set in the past. Please update it or turn it off to save the changes.';
    } else if (isPastReminder) {
      content =
          'The reminder is set in the past. Please update it or turn it off to save the changes.';
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title, style: TextStyle(fontSize: 18)),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.darkBackgroundGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  TaskNameInput(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    onSave: _saveChanges,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TaskNote(
                              controller: _noteController,
                              hintText: 'Note...',
                            ),
                            SizedBox(height: 30),
                            TaskOptionsSection(
                              isDateEnabled: _isDateEnabled,
                              isReminderEnabled: _isReminderEnabled,
                              dueDate: _dueDate,
                              reminder: _reminder,
                              onDateToggle: (value) {
                                setState(() {
                                  _isDateEnabled = value;
                                  if (!value) _dueDate = null;
                                });
                              },
                              onReminderToggle: (value) {
                                setState(() {
                                  _isReminderEnabled = value;
                                  if (!value) _reminder = null;
                                });
                              },
                              onDateSelected: (date) {
                                setState(() {
                                  _dueDate = date;
                                });
                              },
                              onReminderSet: (DateTime newDateTime) {
                                setState(() {
                                  _reminder = newDateTime;
                                });
                              },
                            ),
                            SizedBox(height: 30),
                            PrioritySelector(
                              selectedPriority: _priority,
                              onPriorityChanged: (priority) {
                                setState(() {
                                  _priority = priority;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
