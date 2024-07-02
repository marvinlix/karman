import 'package:flutter/cupertino.dart';
import 'package:karman_app/app_shell.dart';
import 'package:karman_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(KarmanApp());
}

class KarmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: AppShell(),
    );
  }
}
