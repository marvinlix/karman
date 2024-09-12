import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:karman_app/controllers/pomodoro_controller.dart';
import 'package:karman_app/components/pomodoro/pomodoro_timer_display.dart';
import 'package:karman_app/components/pomodoro/pomodoro_session_indicator.dart';
import 'package:karman_app/components/pomodoro/pomodoro_settings_picker.dart';
import 'package:karman_app/components/focus/rolling_menu.dart';
import 'package:karman_app/app_state.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(
      BuildContext context, PomodoroController controller) async {
    if (!controller.isRunning) {
      return true;
    }

    bool? exitConfirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Exit Pomodoro Session?'),
        content:
            Text('Are you sure you want to exit the active Pomodoro session?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'),
          ),
        ],
      ),
    );

    return exitConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PomodoroController(context),
      child: Consumer2<PomodoroController, AppState>(
        builder: (context, controller, appState, child) {
          return WillPopScope(
            onWillPop: () => _onWillPop(context, controller),
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: CupertinoColors.black,
                border: null,
                middle: Text('Pomodoro Timer',
                    style: TextStyle(color: CupertinoColors.white)),
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: controller.isRunning
                      ? null
                      : () async {
                          if (await _onWillPop(context, controller)) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Icon(
                    CupertinoIcons.back,
                    color: controller.isRunning
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.white,
                  ),
                ),
                trailing: controller.isRunning
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _toggleMenu,
                        child: Icon(
                          controller.soundManager.currentIcon,
                          color: CupertinoColors.white,
                        ),
                      )
                    : null,
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PomodoroTimerDisplay(controller: controller),
                        PomodoroSessionIndicator(controller: controller),
                        SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: controller.isRunning
                              ? CupertinoButton(
                                  onPressed: () {
                                    controller.toggleTimer();
                                    appState.setPomodoroActive(false);
                                  },
                                  child: Icon(CupertinoIcons.stop_fill,
                                      color: CupertinoColors.white, size: 40),
                                )
                              : PomodoroSettingsPicker(controller: controller),
                        ),
                        SizedBox(height: 20),
                        if (!controller.isRunning)
                          CupertinoButton(
                            child: Icon(CupertinoIcons.play_fill,
                                color: CupertinoColors.white, size: 40),
                            onPressed: () {
                              controller.toggleTimer();
                              appState.setPomodoroActive(true);
                            },
                          ),
                        SizedBox(height: 40),
                      ],
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
                            child: Container(
                              color: CupertinoColors.black.withOpacity(0.8),
                              child: RollingMenu(
                                items: controller.soundManager.sounds,
                                onItemSelected: (Map<String, dynamic> sound) {
                                  controller.soundManager.currentSound =
                                      sound['file'];
                                  if (sound['file'] == null) {
                                    controller.soundManager
                                        .stopBackgroundSound();
                                  } else {
                                    controller.soundManager.playSelectedSound();
                                  }
                                  _toggleMenu();
                                },
                                currentSound:
                                    controller.soundManager.currentSound,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
