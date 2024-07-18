import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:karman_app/components/focus/circular_slider.dart';
import 'package:karman_app/components/focus/radial_menu.dart';

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
  String? _currentSound;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> sounds = [
    {'name': 'None', 'icon': CupertinoIcons.nosign, 'file': null},
    {
      'name': 'Rain',
      'icon': CupertinoIcons.cloud_rain,
      'file': 'lib/assets/audio/rain.mp3'
    },
    {
      'name': 'Ocean',
      'icon': CupertinoIcons.drop,
      'file': 'lib/assets/audio/ocean.mp3'
    },
    {
      'name': 'Forest',
      'icon': CupertinoIcons.tree,
      'file': 'lib/assets/audio/forest.mp3'
    },
    {
      'name': 'Airplane',
      'icon': CupertinoIcons.airplane,
      'file': 'lib/assets/audio/airplane.mp3'
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
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
        _playSelectedSound();
      } else {
        _stopTimer();
        _audioPlayer.stop();
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
          _audioPlayer.stop();
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

  void _playSelectedSound() async {
    if (_currentSound != null) {
      await _audioPlayer.setAsset(_currentSound!);
      await _audioPlayer.setLoopMode(LoopMode.one);
      _audioPlayer.play();
    }
  }

  void _showRadialMenu() {
    if (_isTimerRunning) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => RadialMenu(
          items: sounds,
          onItemSelected: (Map<String, dynamic> sound) {
            setState(() {
              _currentSound = sound['file'];
              if (sound['file'] == null) {
                _audioPlayer.stop();
              } else {
                _playSelectedSound();
              }
            });
          },
          onDismiss: () => Navigator.of(context).pop(),
          currentSound: _currentSound,
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
    );
  }
}
