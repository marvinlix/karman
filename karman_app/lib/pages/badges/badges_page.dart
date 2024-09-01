import 'package:flutter/cupertino.dart';
import 'package:karman_app/pages/badges/focus_badges_page.dart';
import 'package:karman_app/pages/badges/habit_badges_page.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text('Badges'),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildBadgeCategory(
              context,
              'Focus Badges',
              'Track your focus achievements',
              CupertinoIcons.timer,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FocusBadgesPage(),
                ),
              ),
            ),
            _buildBadgeCategory(
              context,
              'Habit Badges',
              'Track your habit achievements',
              CupertinoIcons.checkmark_seal,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HabitBadgesPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCategory(BuildContext context, String title,
      String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: CupertinoColors.white),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.right_chevron, color: CupertinoColors.white),
          ],
        ),
      ),
    );
  }
}
