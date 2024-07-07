import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/components/date_time/date_button.dart';
import 'package:karman_app/components/date_time/reminders.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/services/notification_service.dart';
import 'package:provider/provider.dart';

class TaskDetailsSheet extends StatefulWidget {
  final Task task;

  const TaskDetailsSheet({
    super.key,
    required this.task,
  });

  @override
  _TaskDetailsSheetState createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  late TextEditingController _noteController;
  late DateTime? _dueDate;
  late int _priority;
  late DateTime? _reminder;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
    _reminder = widget.task.reminder;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedTask = Task(
      taskId: widget.task.taskId,
      name: widget.task.name,
      note: _noteController.text,
      priority: _priority,
      dueDate: _dueDate,
      reminder: _reminder,
      folderId: widget.task.folderId,
    );

    context.read<TaskController>().updateTask(updatedTask);

    // Handle notifications
    if (updatedTask.reminder != null) {
      NotificationService.scheduleNotification(
        id: updatedTask.taskId!,
        title: 'Task Reminder',
        body: updatedTask.name,
        scheduledDate: updatedTask.reminder!,
        payload: 'task_${updatedTask.taskId}',
      );
    } else {
      NotificationService.cancelNotification(updatedTask.taskId!);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.task.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _saveChanges,
                        child: Icon(
                          CupertinoIcons.check_mark_circled,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _noteController,
                          placeholder: 'Add a note...',
                          style: TextStyle(color: Colors.white),
                          decoration: BoxDecoration(
                            color: CupertinoColors
                                .tertiarySystemBackground.darkColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Due Date:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        DateButton(
                          selectedDate: _dueDate,
                          onDateSelected: (date) {
                            setState(() {
                              _dueDate = date;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Priority:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPriorityOption(1, Colors.green),
                            _buildPriorityOption(2, Colors.yellow),
                            _buildPriorityOption(3, Colors.red),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Reminder:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        ReminderButton(
                          selectedDate: _reminder,
                          selectedTime: _reminder != null
                              ? TimeOfDay.fromDateTime(_reminder!)
                              : null,
                          onReminderSet: (date, time) {
                            setState(() {
                              if (date != null && time != null) {
                                _reminder = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              } else {
                                _reminder = null;
                              }
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
        );
      },
    );
  }

  Widget _buildPriorityOption(int priority, Color color) {
    bool isSelected = _priority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = priority;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.flag_fill,
                color: isSelected ? Colors.black : color,
                size: 20,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            priority == 1 ? 'Low' : (priority == 2 ? 'Medium' : 'High'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
