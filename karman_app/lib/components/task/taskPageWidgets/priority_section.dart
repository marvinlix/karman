import 'package:flutter/cupertino.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/components/task/taskPageWidgets/task_tile.dart';

class PrioritySection extends StatelessWidget {
  final int priority;
  final List<Task> tasks;
  final bool isExpanded;
  final Function(int) onToggle;
  final Function(Task) onTaskToggle;
  final Function(BuildContext, int) onTaskDelete;
  final Function(Task) onTaskTap;

  const PrioritySection({
    super.key,
    required this.priority,
    required this.tasks,
    required this.isExpanded,
    required this.onToggle,
    required this.onTaskToggle,
    required this.onTaskDelete,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityTasks = tasks
        .where((task) => task.priority == priority && !task.isCompleted)
        .toList();

    if (priorityTasks.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onToggle(priority),
          child: Container(
            padding: EdgeInsets.only(
              top: 23,
              left: 8,
              right: 8,
              bottom: 13,
            ),
            color: CupertinoColors.black,
            child: Row(
              children: [
                Icon(
                  size: 32,
                  isExpanded
                      ? CupertinoIcons.flag_circle
                      : CupertinoIcons.flag_circle_fill,
                  color: priority == 3
                      ? CupertinoColors.systemRed
                      : (priority == 2
                          ? CupertinoColors.systemYellow
                          : CupertinoColors.systemGreen),
                ),
                SizedBox(width: 10),
                Text(
                  priority == 3 ? 'High' : (priority == 2 ? 'Medium' : 'Low'),
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
          CustomScrollView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = priorityTasks[index];
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      child: TaskTile(
                        key: ValueKey(task.taskId),
                        task: task,
                        onChanged: (value) => onTaskToggle(task),
                        onDelete: (context) =>
                            onTaskDelete(context, task.taskId!),
                        onTap: () => onTaskTap(task),
                      ),
                    );
                  },
                  childCount: priorityTasks.length,
                ),
              ),
            ],
          ),
        SizedBox(height: 16),
      ],
    );
  }
}
