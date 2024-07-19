import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:karman_app/models/task/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onDelete;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Slidable(
        key: ValueKey(task.taskId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.black,
              foregroundColor: Colors.redAccent,
              icon: CupertinoIcons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[800]!,
                width: 1,
              ),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60, // Fixed width for checkbox area
                  child: Center(
                    child: Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: onChanged,
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          task.name,
                          style: TextStyle(
                            color: task.isCompleted ? Colors.grey[700] : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_hasAdditionalInfo)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                if (task.dueDate != null) _buildIcon(CupertinoIcons.calendar),
                                if (task.reminder != null) _buildIcon(CupertinoIcons.clock),
                                if (task.note != null && task.note!.isNotEmpty) _buildIcon(CupertinoIcons.doc_text),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add some padding on the right side
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  bool get _hasAdditionalInfo =>
      task.dueDate != null || task.reminder != null || (task.note != null && task.note!.isNotEmpty);
}