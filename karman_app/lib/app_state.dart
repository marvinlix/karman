import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isPomodoroActive = false;

  bool get isPomodoroActive => _isPomodoroActive;

  void setPomodoroActive(bool value) {
    _isPomodoroActive = value;
    notifyListeners();
  }
}
