import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/focus/circular_slider.dart';
import 'package:karman_app/components/focus/radial_menu.dart';
import 'package:karman_app/manager/sound_manager.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  int _timerValue = 5;
  bool _isTimerRunning = false;
  late Timer _timer;
  int _remainingSeconds = 300;
  int _totalSeconds = 300;
  final SoundManager _soundManager = SoundManager();

  @override
  void dispose() {
    _timer.cancel();
    _soundManager.dispose();
    super.dispose();
  }

  void _onSliderValueChanged(int value) {
    setState(() {
      _timerValue = value;
      _remainingSeconds = value * 60;
      _totalSeconds = _remainingSeconds;
    });
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      if (_isTimerRunning) {
        _startTimer();
        _soundManager.playSelectedSound();
      } else {
        _stopTimer();
        _soundManager.stopBackgroundSound();
      }
    });
  }

  void _startTimer() {
    _totalSeconds = _remainingSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    _isTimerRunning = false;
    _soundManager.stopBackgroundSound();

    Future.delayed(Duration(seconds: 1), () {
      _soundManager.playChime();
    });

    setState(() {
      _remainingSeconds = _timerValue * 60;
      _totalSeconds = _remainingSeconds;
    });
  }

  void _showRadialMenu() {
    if (_isTimerRunning) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => RadialMenu(
          items: _soundManager.sounds,
          onItemSelected: (Map<String, dynamic> sound) {
            setState(() {
              _soundManager.currentSound = sound['file'];
              if (sound['file'] == null) {
                _soundManager.stopBackgroundSound();
              } else {
                _soundManager.playSelectedSound();
              }
            });
          },
          onDismiss: () => Navigator.of(context).pop(),
          currentSound: _soundManager.currentSound,
        ),
      );
    }
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
        trailing: CupertinoButton(
          onPressed: _isTimerRunning ? _showRadialMenu : null,
          child: Icon(
            CupertinoIcons.music_note_2,
            color: _isTimerRunning
                ? CupertinoColors.white
                : CupertinoColors.systemGrey,
            size: 32,
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
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
      ),
    );
  }
}
