import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Work in Progress!',
                style: GoogleFonts.knewave(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset('lib/assets/images/wip/work_in_progress.png'),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
