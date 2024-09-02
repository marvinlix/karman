import 'package:flutter/cupertino.dart';

class HabitBadgesPage extends StatelessWidget {
  const HabitBadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Text('Habit Badges'),
      ),
      child: SafeArea(
        child: Center(
          child: Text(
            'Coming Soon!',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
