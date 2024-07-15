import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/habit/habit_tile.dart';
import 'package:karman_app/controllers/habit/habit_controller.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:karman_app/pages/habit/habit_details_sheet.dart';
import 'package:provider/provider.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final TextEditingController _habitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final habitController =
          Provider.of<HabitController>(context, listen: false);
      habitController.checkAndResetStreaks();
      habitController.loadHabits();
    });
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  void _showAddHabitDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add New Habit'),
          content: CupertinoTextField(
            controller: _habitNameController,
            placeholder: 'Enter habit name',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                _habitNameController.clear();
              },
            ),
            CupertinoDialogAction(
              child: Text('Add'),
              onPressed: () {
                if (_habitNameController.text.isNotEmpty) {
                  final newHabit = Habit(habitName: _habitNameController.text);
                  Provider.of<HabitController>(context, listen: false)
                      .addHabit(newHabit);
                  Navigator.pop(context);
                  _habitNameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showHabitDetailsSheet(BuildContext context, Habit habit) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => HabitDetailsSheet(habit: habit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitController>(
      builder: (context, habitController, child) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _showAddHabitDialog,
              child: Icon(
                CupertinoIcons.add_circled_solid,
                color: CupertinoColors.white,
                size: 22,
              ),
            ),
          ),
          child: SafeArea(
            child: habitController.habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits yet. Add one to get started!',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  )
                : ListView.builder(
                    itemCount: habitController.habits.length,
                    itemBuilder: (context, index) {
                      final habit = habitController.habits[index];
                      return HabitTile(
                        habit: habit,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
