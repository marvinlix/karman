import 'package:flutter/cupertino.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/components/task/taskPageWidgets/task_tile.dart';

class CompletedSection extends StatelessWidget {
  final List<Task> tasks;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(Task) onTaskToggle;
  final Function(BuildContext, int) onTaskDelete;
  final Function(Task) onTaskTap;

  const CompletedSection({
    super.key,
    required this.tasks,
    required this.isExpanded,
    required this.onToggle,
    required this.onTaskToggle,
    required this.onTaskDelete,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    if (completedTasks.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: CupertinoColors.black,
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? CupertinoIcons.checkmark_circle
                      : CupertinoIcons.checkmark_circle_fill,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(width: 10),
                Text(
                  'Completed',
                  style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  isExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: CupertinoColors.white,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              return TaskTile(
                key: ValueKey(completedTasks[index].taskId),
                task: completedTasks[index],
                onChanged: (value) => onTaskToggle(completedTasks[index]),
                onDelete: (context) =>
                    onTaskDelete(context, completedTasks[index].taskId!),
                onTap: () => onTaskTap(completedTasks[index]),
              );
            },
          ),
      ],
    );
  }
}
