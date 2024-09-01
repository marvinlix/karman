import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:karman_app/constants/focus_badge_constants.dart';
import 'package:karman_app/services/focus_badge_service.dart';

class FocusBadgesPage extends StatefulWidget {
  const FocusBadgesPage({super.key});

  @override
  _FocusBadgesPageState createState() => _FocusBadgesPageState();
}

class _FocusBadgesPageState extends State<FocusBadgesPage> {
  final FocusBadgeService _focusBadgeService = FocusBadgeService();
  Map<String, bool> unlockedBadges = {};
  bool _isInitialLoad = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initialLoadBadges();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initialLoadBadges() async {
    final newUnlockedBadges = await _focusBadgeService.checkFocusBadges();
    setState(() {
      unlockedBadges = newUnlockedBadges;
      _isInitialLoad = false;
    });
  }

  Future<void> _refreshBadges() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final newUnlockedBadges = await _focusBadgeService.checkFocusBadges();
      setState(() {
        unlockedBadges = newUnlockedBadges;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text('Focus Badges'),
      ),
      child: SafeArea(
        child: _isInitialLoad
            ? Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _refreshBadges,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < FocusBadgeConstants.focusBadges.length) {
                          final badge = FocusBadgeConstants.focusBadges[index];
                          final isUnlocked =
                              unlockedBadges[badge.name] ?? false;
                          return _buildBadgeTile(badge, isUnlocked);
                        } else {
                          return _buildFooter();
                        }
                      },
                      childCount: FocusBadgeConstants.focusBadges.length + 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBadgeTile(FocusBadge badge, bool isUnlocked) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Container(
        key: ValueKey('${badge.name}_$isUnlocked'),
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
                    badge.name,
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
                    badge.description,
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
          "More focus badges coming soon...",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ),
    );
  }
}
