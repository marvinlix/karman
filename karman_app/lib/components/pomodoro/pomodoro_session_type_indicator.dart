import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        Icon(
          CupertinoIcons.hourglass,
          color: isFocusSession && isRunning
              ? CupertinoColors.white
              : CupertinoColors.systemGrey,
          size: 32,
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
