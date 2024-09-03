import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karman_app/manager/sound_manager.dart';
import 'package:karman_app/services/timer_service.dart';
import 'package:karman_app/services/focus_service.dart';
import 'package:karman_app/services/focus_badge_service.dart';

class FocusController extends ChangeNotifier {
  final SoundManager _soundManager = SoundManager();
  final TimerService _timerService = TimerService();
  final FocusService _focusService = FocusService();
  final FocusBadgeService _achievementService = FocusBadgeService();

  int _timerValue = 1;
  bool _isTimerRunning = false;
  late DateTime _endTime;
  Timer? _timer;
  int _remainingSeconds = 60;
  int _totalSeconds = 60;

  int get timerValue => _timerValue;
  bool get isTimerRunning => _isTimerRunning;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  SoundManager get soundManager => _soundManager;

  FocusController() {
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final timerState = await _timerService.getTimerState();
    _timerValue = timerState['timerValue'];
    _isTimerRunning = timerState['isTimerRunning'];
    _remainingSeconds = timerState['remainingSeconds'];
    _totalSeconds = timerState['totalSeconds'];
    notifyListeners();
    if (_isTimerRunning) {
      _startTimer();
      _soundManager.playSelectedSound();
    }
  }

  void onSliderValueChanged(int value) {
    _timerValue = value;
    _remainingSeconds = value * 60;
    _totalSeconds = _remainingSeconds;
    _saveTimerState();
    notifyListeners();
  }

  void toggleTimer() {
    _isTimerRunning = !_isTimerRunning;
    if (_isTimerRunning) {
      _startTimer();
      _soundManager.playSelectedSound();
    } else {
      _stopTimer(playChime: false);
    }
    _saveTimerState();
    notifyListeners();
  }

  void _startTimer() {
    _endTime = DateTime.now().add(Duration(seconds: _remainingSeconds));
    _updateTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
  }

  void _updateTimer() {
    final now = DateTime.now();
    if (now.isBefore(_endTime)) {
      _remainingSeconds = _endTime.difference(now).inSeconds;
      _saveTimerState();
      notifyListeners();
    } else {
      _stopTimer(playChime: true);
    }
  }

  void _stopTimer({required bool playChime}) {
    _timer?.cancel();
    _isTimerRunning = false;
    _soundManager.stopBackgroundSound();

    if (playChime) {
      Future.delayed(Duration(seconds: 1), () {
        _soundManager.playChime();
      });
      _recordFocusSession();
    } else {
      _remainingSeconds = _timerValue * 60;
      _totalSeconds = _remainingSeconds;
    }
    _saveTimerState();
    notifyListeners();
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
    final duration = _timerValue * 60;
    await _focusService.addFocusSession(duration);

    Map<String, bool> unlockedAchievements =
        await _achievementService.checkFocusBadges();

    _remainingSeconds = _timerValue * 60;
    _totalSeconds = _remainingSeconds;
    _saveTimerState();
    notifyListeners();

    if (unlockedAchievements.values.any((value) => value)) {
      // TODO: Notify the UI to show achievements
      // Use a callback or a stream for this
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (_totalSeconds == 0) return 0;
    return (_totalSeconds - _remainingSeconds) / _totalSeconds * 115 + 5;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _soundManager.dispose();
    super.dispose();
  }
}
