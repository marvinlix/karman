import 'package:flutter/cupertino.dart';
import 'package:karman_app/pages/more/details/community_page.dart';
import 'package:karman_app/pages/more/details/contribution_page.dart';
import 'package:karman_app/pages/more/details/support_page.dart';
import 'package:karman_app/pages/more/focus_badges_page.dart';
import 'package:karman_app/pages/more/habit_badges_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Achievements Section
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    context,
                    'Focus Badges',
                    CupertinoIcons.timer,
                    () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FocusBadgesPage(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildActionTile(
                    context,
                    'Habit Badges',
                    CupertinoIcons.checkmark_seal,
                    () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HabitBadgesPage(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Make Karman Better Section
            Text(
              'Make Karman Better',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
            SizedBox(height: 16),
            _buildNavigationTile(
              context,
              'Contribute on GitHub',
              CupertinoIcons.cube_box,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => contributionPage,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildNavigationTile(
              context,
              'Join the Community',
              CupertinoIcons.group,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => communityPage,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildNavigationTile(
              context,
              'Support the Project',
              CupertinoIcons.heart,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => supportPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: CupertinoColors.white),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: CupertinoColors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.white,
              ),
            ),
            Spacer(),
            Icon(CupertinoIcons.right_chevron, color: CupertinoColors.white),
          ],
        ),
      ),
    );
  }
}
