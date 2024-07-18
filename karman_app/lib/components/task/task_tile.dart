import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:karman_app/models/task/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: onChanged,
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  shape: const CircleBorder(),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: TextStyle(
                          color: task.isCompleted
                              ? Colors.grey[700]
                              : Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (task.dueDate != null) _buildDateIcon(),
                          if (task.dueDate != null) const SizedBox(width: 24),
                          if (task.reminder != null) _buildReminderIcon(),
                          if (task.reminder != null) const SizedBox(width: 24),
                          if (task.note != null && task.note!.isNotEmpty)
                            _buildNoteIcon(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateIcon() {
    return const Icon(CupertinoIcons.calendar, color: Colors.white, size: 20);
  }

  Widget _buildReminderIcon() {
    return const Icon(CupertinoIcons.clock, color: Colors.white, size: 20);
  }

  Widget _buildNoteIcon() {
    return const Icon(CupertinoIcons.doc_text, color: Colors.white, size: 20);
  }
}
