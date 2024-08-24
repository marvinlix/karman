import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/habit/habit_tile.dart';
import 'package:karman_app/controllers/habit/habit_controller.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:karman_app/pages/habit/habit_details_sheet.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadHabits() async {
    final habitController =
        Provider.of<HabitController>(context, listen: false);
    await habitController.loadHabits();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshHabits() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final habitController =
          Provider.of<HabitController>(context, listen: false);
      await habitController.loadHabits();
    });
  }

  void _showAddHabitDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => HabitDetailsSheet(
        habit: Habit(
          habitName: '',
          startDate: DateTime.now(),
        ),
        isNewHabit: true,
      ),
    );
  }

  List<Habit> _sortHabits(List<Habit> habits) {
    habits.sort((a, b) {
      if (a.isCompletedToday == b.isCompletedToday) {
        return 0;
      }
      return a.isCompletedToday ? 1 : -1;
    });
    return habits;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitController>(
      builder: (context, habitController, child) {
        final sortedHabits = _sortHabits(habitController.habits);
        final incompleteHabits =
            sortedHabits.where((habit) => !habit.isCompletedToday).length;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            middle: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                sortedHabits.isEmpty
                    ? 'No habits left'
                    : '$incompleteHabits habit${incompleteHabits == 1 ? '' : 's'} left',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: CupertinoButton(
              onPressed: _showAddHabitDialog,
              child: Icon(
                CupertinoIcons.plus_circle,
                color: CupertinoColors.white,
                size: 32,
              ),
            ),
          ),
          child: SafeArea(
            child: _isLoading
                ? Center(child: CupertinoActivityIndicator())
                : sortedHabits.isEmpty
                    ? _buildEmptyState()
                    : CustomScrollView(
                        slivers: [
                          CupertinoSliverRefreshControl(
                            onRefresh: _refreshHabits,
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(top: 20.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index < sortedHabits.length) {
                                    final habit = sortedHabits[index];
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 300),
                                      child: HabitTile(
                                        key: ValueKey(habit.habitId),
                                        habit: habit,
                                      ),
                                    );
                                  }
                                  return SizedBox(height: 40);
                                },
                                childCount: sortedHabits.length + 1,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No habits yet. Add one to get started!',
        style: TextStyle(
          fontSize: 18,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}
