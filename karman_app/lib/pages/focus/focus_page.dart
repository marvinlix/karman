import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/focus/circular_slider.dart';
import 'package:karman_app/components/focus/rolling_menu.dart';
import 'package:karman_app/manager/sound_manager.dart';
import 'package:karman_app/database/database_service.dart';
import 'package:karman_app/database/focus_db.dart';
import 'package:karman_app/services/achievement/achievement_service.dart';
import 'package:karman_app/services/focus/timer_service.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage>
    with SingleTickerProviderStateMixin {
  int _timerValue = 5;
  bool _isTimerRunning = false;
  late Timer _timer;
  int _remainingSeconds = 300;
  int _totalSeconds = 300;
  final SoundManager _soundManager = SoundManager();
  final FocusDatabase _focusDatabase = FocusDatabase();
  final AchievementService _achievementService = AchievementService();
  final TimerService _timerService = TimerService();

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final timerState = await _timerService.getTimerState();
    setState(() {
      _timerValue = timerState['timerValue'];
      _isTimerRunning = timerState['isTimerRunning'];
      _remainingSeconds = timerState['remainingSeconds'];
      _totalSeconds = timerState['totalSeconds'];
    });
    if (_isTimerRunning) {
      _startTimer();
      _soundManager.playSelectedSound();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _soundManager.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSliderValueChanged(int value) {
    setState(() {
      _timerValue = value;
      _remainingSeconds = value * 60;
      _totalSeconds = _remainingSeconds;
    });
    _saveTimerState();
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      if (_isTimerRunning) {
        _startTimer();
        _soundManager.playSelectedSound();
      } else {
        _stopTimer(playChime: false);
      }
    });
    _saveTimerState();
  }

  void _startTimer() {
    _totalSeconds = _remainingSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _saveTimerState();
        } else {
          _stopTimer(playChime: true);
        }
      });
    });
  }

  void _stopTimer({required bool playChime}) {
    _timer.cancel();
    _isTimerRunning = false;
    _soundManager.stopBackgroundSound();

    if (_isMenuOpen) {
      _toggleMenu();
    }

    if (playChime) {
      Future.delayed(Duration(seconds: 1), () {
        _soundManager.playChime();
      });

      _recordFocusSession();
    } else {
      // Timer was cancelled, so we reset without recording
      setState(() {
        _remainingSeconds = _timerValue * 60;
        _totalSeconds = _remainingSeconds;
      });
    }
    _saveTimerState();
  }

  Future<void> _saveTimerState() async {
    await _timerService.saveTimerState(
      timerValue: _timerValue,
      isTimerRunning: _isTimerRunning,
      remainingSeconds: _remainingSeconds,
      totalSeconds: _totalSeconds,
    );
  }

  void _recordFocusSession() async {
    final database = await DatabaseService().database;
    final duration = _timerValue * 60; // Record full session duration
    final date = DateTime.now().toIso8601String().split('T')[0];
    await _focusDatabase.addFocusSession(database, duration, date);

    Map<String, bool> unlockedAchievements =
        await _achievementService.checkAchievements();
    _showNewAchievements(unlockedAchievements);

    // Reset timer after recording
    setState(() {
      _remainingSeconds = _timerValue * 60;
      _totalSeconds = _remainingSeconds;
    });
    _saveTimerState();
  }

  void _showNewAchievements(Map<String, bool> unlockedAchievements) {
    List<String> newAchievements = unlockedAchievements.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (newAchievements.isNotEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('New Achievements Unlocked!'),
            content: Column(
              children: newAchievements
                  .map((achievement) => Text(achievement))
                  .toList(),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_totalSeconds == 0) return 0;
    return (_totalSeconds - _remainingSeconds) / _totalSeconds * 115 + 5;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        trailing: _isTimerRunning
            ? CupertinoButton(
                onPressed: _isTimerRunning ? _toggleMenu : null,
                child: Icon(
                  _soundManager.currentIcon,
                  color: _isTimerRunning
                      ? CupertinoColors.white
                      : CupertinoColors.systemGrey,
                  size: 32,
                ),
              )
            : null,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularSlider(
                  onValueChanged: _onSliderValueChanged,
                  currentValue: _timerValue,
                  isTimerRunning: _isTimerRunning,
                  timeDisplay: _formatTime(_remainingSeconds),
                  progress: _progress,
                  onPlayPause: _toggleTimer,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 44),
                  SizeTransition(
                    sizeFactor: _animation,
                    axisAlignment: -1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: RollingMenu(
                        items: _soundManager.sounds,
                        onItemSelected: (Map<String, dynamic> sound) {
                          setState(() {
                            _soundManager.currentSound = sound['file'];
                            if (sound['file'] == null) {
                              _soundManager.stopBackgroundSound();
                            } else if (_isTimerRunning) {
                              _soundManager.playSelectedSound();
                            }
                            _toggleMenu();
                          });
                        },
                        currentSound: _soundManager.currentSound,
                      ),
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
}
