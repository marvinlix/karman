import 'package:flutter/cupertino.dart';
import 'package:karman_app/app_shell.dart';
import 'package:karman_app/controllers/habit_controller.dart';
import 'package:karman_app/controllers/task_controller.dart';
import 'package:karman_app/pages/welcome/welcome_screen.dart';
import 'package:karman_app/pages/welcome/welcome_service.dart';
import 'package:karman_app/services/notifications/notification_service.dart';
import 'package:karman_app/services/notifications/pomodoro_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:karman_app/database/database_service.dart';
import 'package:karman_app/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  await NotificationService.init(navigatorKey);
  await PomodoroNotificationService.initialize();
  tz.initializeTimeZones();

  final databaseService = DatabaseService();
  await databaseService.ensureInitialized();

  final taskController = TaskController();
  final habitController = HabitController();

  await taskController.loadTasks();
  await habitController.loadHabits();

  final shouldShowWelcome = await WelcomeService.shouldShowWelcomeScreen();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => taskController),
      ChangeNotifierProvider(create: (context) => habitController),
      ChangeNotifierProvider(create: (context) => AppState()),
    ],
    child: KarmanApp(
      navigatorKey: navigatorKey,
      showWelcome: shouldShowWelcome,
    ),
  ));
}

class KarmanApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final bool showWelcome;

  const KarmanApp({
    super.key,
    required this.navigatorKey,
    required this.showWelcome,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: showWelcome
          ? const WelcomeScreen()
          : AppShell(key: AppShell.globalKey),
    );
  }
}
