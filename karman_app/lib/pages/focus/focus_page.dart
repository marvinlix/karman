import 'package:flutter/cupertino.dart';
import 'package:karman_app/components/focus/circular_slider.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
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
      } else {
        _stopTimer();
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
    _remainingSeconds = _timerValue * 60;
    _totalSeconds = _remainingSeconds;
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
        leading: CupertinoButton(
          onPressed: () {},
          child: Icon(
            CupertinoIcons.music_note_2,
            color: CupertinoColors.white,
            size: 32,
          ),
        ),
        trailing: CupertinoButton(
          onPressed: () {},
          child: Icon(
            CupertinoIcons.flame_fill,
            color: CupertinoColors.white,
            size: 32,
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularSlider(
                onValueChanged: _onSliderValueChanged,
                currentValue: _timerValue,
                isTimerRunning: _isTimerRunning,
                timeDisplay: _formatTime(_remainingSeconds),
                progress: _progress,
              ),
              SizedBox(height: 20),
              CupertinoButton(
                onPressed: _toggleTimer,
                child: Icon(
                  _isTimerRunning
                      ? CupertinoIcons.stop_circle
                      : CupertinoIcons.play_circle,
                  color: CupertinoColors.white,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
