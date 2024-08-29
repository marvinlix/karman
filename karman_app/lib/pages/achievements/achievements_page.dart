import 'package:flutter/cupertino.dart';
import 'package:karman_app/constants/achievements_constants.dart';
import 'package:karman_app/services/achievement_service.dart';
import 'dart:async';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final AchievementService _achievementService = AchievementService();
  Map<String, bool> unlockedAchievements = {};
  bool _isInitialLoad = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initialLoadAchievements();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initialLoadAchievements() async {
    final newUnlockedAchievements =
        await _achievementService.checkAchievements();
    setState(() {
      unlockedAchievements = newUnlockedAchievements;
      _isInitialLoad = false;
    });
  }

  Future<void> _refreshAchievements() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final newUnlockedAchievements =
          await _achievementService.checkAchievements();
      setState(() {
        unlockedAchievements = newUnlockedAchievements;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: _isInitialLoad
            ? Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _refreshAchievements,
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
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Container(
        key: ValueKey('${achievement.name}_$isUnlocked'),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isUnlocked ? CupertinoIcons.rosette : CupertinoIcons.lock,
              size: 40,
              color: isUnlocked
                  ? CupertinoColors.white
                  : CupertinoColors.systemGrey,
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
                          : CupertinoColors.systemGrey,
                    ),
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
