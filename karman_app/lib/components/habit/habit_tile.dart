import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:karman_app/components/icon_selection_dialog.dart.dart';
import 'package:karman_app/models/habits/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onCheckmark;
  final Function(IconData) onIconChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onCheckmark,
    required this.onIconChanged,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: Slidable(
          key: ValueKey(habit.habitId),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: onEdit,
                backgroundColor: Colors.black,
                foregroundColor: Colors.blueAccent,
                icon: CupertinoIcons.pen,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: onDelete,
                backgroundColor: Colors.black,
                foregroundColor: Colors.redAccent,
                icon: CupertinoIcons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.systemGrey.darkColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => IconSelectionDialog(
                          onIconSelected: onIconChanged,
                        ),
                      );
                    },
                    child: Icon(
                      habit.icon ?? CupertinoIcons.circle,
                      color: CupertinoColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      habit.name,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStreakIcon(),
                  const SizedBox(width: 16),
                  _buildCheckmarkIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          CupertinoIcons.flame,
          color: CupertinoColors.systemOrange,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '${habit.currentStreak}',
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckmarkIcon() {
    return GestureDetector(
      onTap: onCheckmark,
      child: Icon(
        CupertinoIcons.checkmark_circle_fill,
        color:
            habit.status ? CupertinoColors.white : CupertinoColors.systemGrey,
        size: 20,
      ),
    );
  }
}
