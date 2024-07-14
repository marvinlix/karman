import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task.dart';

class CompletedTasksHeader extends StatelessWidget {
  final Function(List<Task>) onClearCompletedTasks;

  const CompletedTasksHeader({
    super.key,
    required this.onClearCompletedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        final completedTasks = taskController.getCompletedTasks();
        final completedCount = completedTasks.length;
        final isActive = completedCount > 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount Completed',
                style: TextStyle(
                  color: isActive
                      ? CupertinoColors.white
                      : CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: isActive
                    ? () => _showClearConfirmation(context, completedTasks)
                    : null,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: isActive
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearConfirmation(BuildContext context, List<Task> completedTasks) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Clear completed tasks?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
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
                onClearCompletedTasks(completedTasks);
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
