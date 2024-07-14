import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/dialog_window.dart';
import 'package:karman_app/components/habit/habit_tile.dart';
import 'package:karman_app/controllers/habit/habit_controller.dart';
import 'package:provider/provider.dart';
import 'package:karman_app/models/habits/habit.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final TextEditingController _habitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitController>(context, listen: false).loadHabits();
    });
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitController>(
      builder: (context, habitController, child) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            middle: const Text(
              'Habits',
              style: TextStyle(color: CupertinoColors.white),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showAddHabitDialog(context, habitController),
              child: const Icon(
                CupertinoIcons.add,
                color: CupertinoColors.white,
              ),
            ),
          ),
          child: SafeArea(
            child: ListView.builder(
              itemCount: habitController.habits.length,
              itemBuilder: (context, index) {
                final habit = habitController.habits[index];
                return HabitTile(
                  habit: habit,
                  onTap: () => _showHabitDetails(context, habit),
                  onCheckmark: () => habitController.toggleHabitStatus(habit),
                  onIconChanged: (IconData selectedIcon) =>
                      _updateHabitIcon(habitController, habit, selectedIcon),
                  onEdit: (_) => _editHabit(context, habitController, habit),
                  onDelete: (_) =>
                      _deleteHabit(context, habitController, habit),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddHabitDialog(BuildContext context, HabitController controller) {
    _habitNameController.clear();
    showCupertinoDialog(
      context: context,
      builder: (context) => KarmanDialogWindow(
        title: 'Add Habit',
        placeholder: 'Enter habit name',
        controller: _habitNameController,
        onSave: () async {
          if (_habitNameController.text.isNotEmpty) {
            await _addHabit(controller, _habitNameController.text);
            Navigator.pop(context);
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _addHabit(HabitController controller, String name) async {
    final newHabit = Habit(
      name: name,
      status: false,
      startDate: DateTime.now(),
      currentStreak: 0,
      longestStreak: 0,
    );
    await controller.addHabit(newHabit);
  }

  void _showHabitDetails(BuildContext context, Habit habit) {
    // TODO: Implement habit details page navigation
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(habit.name),
        content: const Text('Habit details page to be implemented.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _updateHabitIcon(
      HabitController controller, Habit habit, IconData selectedIcon) async {
    final updatedHabit = habit.copyWith(icon: selectedIcon);
    await controller.updateHabit(updatedHabit);
  }

  void _editHabit(
      BuildContext context, HabitController controller, Habit habit) {
    _habitNameController.text = habit.name;
    showCupertinoDialog(
      context: context,
      builder: (context) => KarmanDialogWindow(
        title: 'Edit Habit',
        placeholder: 'Enter habit name',
        controller: _habitNameController,
        onSave: () async {
          if (_habitNameController.text.isNotEmpty) {
            final updatedHabit =
                habit.copyWith(name: _habitNameController.text);
            await controller.updateHabit(updatedHabit);
            Navigator.pop(context);
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _deleteHabit(
      BuildContext context, HabitController controller, Habit habit) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () async {
              await controller.deleteHabit(habit.habitId!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
