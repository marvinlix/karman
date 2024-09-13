import 'package:flutter/cupertino.dart';
import 'tutorial_overlay.dart';

class PomodoroTutorial {
  static List<TutorialPage> pages = [
    TutorialPage(
      instruction: 'Set your focus and break durations',
      imageAsset: 'lib/assets/tutorials/pomodoro/set_durations.png',
    ),
    TutorialPage(
      instruction: 'Start your Pomodoro session',
      imageAsset: 'lib/assets/tutorials/pomodoro/start_session.png',
    ),
    TutorialPage(
      instruction: 'Track your progress',
      imageAsset: 'lib/assets/tutorials/pomodoro/track_progress.png',
    ),
    TutorialPage(
      instruction: 'Choose background sounds',
      imageAsset: 'lib/assets/tutorials/pomodoro/choose_sounds.png',
    ),
  ];

  static Widget build(BuildContext context, VoidCallback onComplete) {
    return TutorialOverlay(
      pages: pages,
      onComplete: onComplete,
    );
  }
}
