import 'package:flutter/cupertino.dart';
import 'package:karman_app/controllers/pomodoro_controller.dart';

class PomodoroTimerDisplay extends StatelessWidget {
  final PomodoroController controller;

  const PomodoroTimerDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          controller.formattedTime,
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}
