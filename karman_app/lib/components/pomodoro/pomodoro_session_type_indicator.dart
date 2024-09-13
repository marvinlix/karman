import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PomodoroSessionTypeIndicator extends StatelessWidget {
  final bool isFocusSession;
  final bool isRunning;

  const PomodoroSessionTypeIndicator({
    super.key,
    required this.isFocusSession,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          isFocusSession && isRunning
              ? 'lib/assets/images/pomodoro/pomo_active.svg'
              : 'lib/assets/images/pomodoro/pomo_inactive.svg',
          width: 30,
          height: 30,
        ),
        SizedBox(width: 40),
        Icon(
          Icons.coffee,
          color: !isFocusSession && isRunning
              ? CupertinoColors.white
              : CupertinoColors.systemGrey,
          size: 32,
        ),
      ],
    );
  }
}
