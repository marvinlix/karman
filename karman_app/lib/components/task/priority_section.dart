import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/models/task/task.dart';
import 'package:karman_app/components/task/task_tile.dart';

class PrioritySection extends StatelessWidget {
  final int priority;
  final List<Task> tasks;
  final bool isExpanded;
  final Function(int) onToggle;
  final Function(Task) onTaskToggle;
  final Function(BuildContext, int) onTaskDelete;

  const PrioritySection({
    super.key,
    required this.priority,
    required this.tasks,
    required this.isExpanded,
    required this.onToggle,
    required this.onTaskToggle,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tasksInPriority = tasks.where((task) => task.priority == priority && !task.isCompleted).toList();

    if (tasksInPriority.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onToggle(priority),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: CupertinoColors.black,
            child: Row(
              children: [
                Icon(
                  isExpanded ? CupertinoIcons.flag_circle : CupertinoIcons.flag_circle_fill,
                  color: priority == 3 ? Colors.red : (priority == 2 ? Colors.yellow : Colors.green),
                ),
                SizedBox(width: 10),
                Text(
                  priority == 3 ? 'High' : (priority == 2 ? 'Medium' : 'Low'),
                  style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
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
            itemCount: tasksInPriority.length,
            itemBuilder: (context, index) {
              return TaskTile(
                key: ValueKey(tasksInPriority[index].taskId),
                task: tasksInPriority[index],
                onChanged: (value) => onTaskToggle(tasksInPriority[index]),
                onDelete: (context) => onTaskDelete(context, tasksInPriority[index].taskId!),
              );
            },
          ),
        SizedBox(height: 16),
      ],
    );
  }
}