import 'package:flutter/cupertino.dart';
import 'package:karman_app/constants/achievements_constants.dart';
import 'package:karman_app/services/achievement/achievement_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final AchievementService _achievementService = AchievementService();
  Map<String, bool> unlockedAchievements = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });
    unlockedAchievements = await _achievementService.checkAchievements();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: _isLoading
            ? Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _loadAchievements,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < AchievementConstants.achievements.length) {
                          final achievement =
                              AchievementConstants.achievements[index];
                          final isUnlocked =
                              unlockedAchievements[achievement.name] ?? false;
                          return _buildAchievementTile(achievement, isUnlocked);
                        } else {
                          return _buildFooter();
                        }
                      },
                      childCount: AchievementConstants.achievements.length + 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAchievementTile(Achievement achievement, bool isUnlocked) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            isUnlocked ? CupertinoIcons.rosette : CupertinoIcons.lock,
            size: 40,
            color:
                isUnlocked ? CupertinoColors.white : CupertinoColors.systemGrey,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? CupertinoColors.white
                          : CupertinoColors.systemGrey),
                ),
                SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          "More badges coming soon...",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}
