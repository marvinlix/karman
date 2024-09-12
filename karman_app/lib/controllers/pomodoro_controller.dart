import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:karman_app/app_state.dart';
import 'package:karman_app/services/focus_service.dart';
import 'package:provider/provider.dart';
import 'package:karman_app/manager/sound_manager.dart';

class PomodoroController extends ChangeNotifier {
  final FocusService _focusService = FocusService();
  final BuildContext _context;
  final SoundManager soundManager = SoundManager();

  Timer? _timer;
  bool _isRunning = false;
  bool _isFocusSession = true;
  int _currentSession = 0;
  int _focusDuration = 25;
  int _breakDuration = 5;
  int _totalSessions = 4;
  Duration _currentDuration = Duration(minutes: 25);
  bool _isSoundMenuOpen = false;

  bool get isRunning => _isRunning;
  bool get isFocusSession => _isFocusSession;
  int get currentSession => _currentSession;
  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
  int get totalSessions => _totalSessions;
  Duration get currentDuration => _currentDuration;
  bool get isSoundMenuOpen => _isSoundMenuOpen;

  List<int> focusDurations = [15, 20, 25, 30, 35];
  List<int> breakDurations = [5, 10, 15];
  List<int> sessionOptions = [4, 5, 6];

  PomodoroController(this._context);

  String get formattedTime {
    int minutes = _currentDuration.inMinutes;
    int seconds = _currentDuration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    int totalSeconds =
        _isFocusSession ? _focusDuration * 60 : _breakDuration * 60;
    int elapsedSeconds = totalSeconds - _currentDuration.inSeconds;
    return elapsedSeconds / totalSeconds;
  }

  Future<bool> handleWillPop(BuildContext context) async {
    if (_isRunning) {
      _showWarningDialog(context);
      return false;
    }
    return true;
  }

  void _showWarningDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Pomodoro Timer Active'),
        content: Text(
            'Please complete or stop the Pomodoro session before leaving.'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    Provider.of<AppState>(_context, listen: false).setPomodoroActive(true);
    soundManager.playSelectedSound();
    notifyListeners();
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    Provider.of<AppState>(_context, listen: false).setPomodoroActive(false);
    soundManager.stopBackgroundSound();
    _resetTimer();
    notifyListeners();
  }

  void _updateTimer(Timer timer) {
    if (_currentDuration.inSeconds > 0) {
      _currentDuration = _currentDuration - Duration(seconds: 1);
    } else {
      if (_isFocusSession) {
        _focusService.addFocusSession(_focusDuration * 60);
      }
      _switchSession();
    }
    notifyListeners();
  }

  void _switchSession() {
    if (_isFocusSession) {
      if (_currentSession < _totalSessions - 1) {
        _isFocusSession = false;
        _currentDuration = Duration(minutes: _breakDuration);
      } else {
        _stopTimer();
        _resetTimer();
      }
    } else {
      _isFocusSession = true;
      _currentSession++;
      _currentDuration = Duration(minutes: _focusDuration);
    }
  }

  void _resetTimer() {
    _currentSession = 0;
    _isFocusSession = true;
    _currentDuration = Duration(minutes: _focusDuration);
  }

  void setFocusDuration(int duration) {
    _focusDuration = duration;
    if (_isFocusSession && !_isRunning) {
      _currentDuration = Duration(minutes: duration);
    }
    notifyListeners();
  }

  void setBreakDuration(int duration) {
    _breakDuration = duration;
    if (!_isFocusSession && !_isRunning) {
      _currentDuration = Duration(minutes: duration);
    }
    notifyListeners();
  }

  void setTotalSessions(int sessions) {
    _totalSessions = sessions;
    notifyListeners();
  }

  void toggleSoundMenu() {
    _isSoundMenuOpen = !_isSoundMenuOpen;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    soundManager.dispose();
    super.dispose();
  }
}
