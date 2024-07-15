import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:karman_app/controllers/habit/habit_controller.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:provider/provider.dart';

class HabitLogsPage extends StatelessWidget {
  final Habit habit;

  const HabitLogsPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text('Habit Logs'),
      ),
      child: SafeArea(
        child: FutureBuilder<void>(
          future: context.read<HabitController>().loadHabitLogs(habit.habitId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return Consumer<HabitController>(
              builder: (context, controller, child) {
                final logs = controller.habitLogs[habit.habitId] ?? [];

                if (logs.isEmpty) {
                  return Center(child: Text('No logs available'));
                }

                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: CupertinoColors.systemGrey),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM d, y').format(log.date),
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            log.log ?? 'No log entry',
                            style: TextStyle(
                                color: CupertinoColors.white, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            log.completedForToday
                                ? 'Completed'
                                : 'Not Completed',
                            style: TextStyle(
                              color: log.completedForToday
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.systemRed,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
