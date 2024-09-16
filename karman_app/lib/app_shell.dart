import 'package:flutter/cupertino.dart';
import 'package:karman_app/pages/more/more_page.dart';
import 'package:karman_app/pages/habit/habits_page.dart';
import 'package:karman_app/pages/task/tasks_page.dart';
import 'package:karman_app/pages/focus/focus_page.dart';

class AppShell extends StatefulWidget {
  static final GlobalKey<AppShellState> globalKey = GlobalKey<AppShellState>();

  const AppShell({super.key});

  @override
  AppShellState createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  final CupertinoTabController _controller =
      CupertinoTabController(initialIndex: 1);

  void switchToTab(int index) {
    setState(() {
      _controller.index = index;
    });
  }

   @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _controller,
      tabBar: CupertinoTabBar(
        iconSize: 32,
        backgroundColor: CupertinoColors.black,
        activeColor: CupertinoColors.white,
        height: 60, // Increase the height of the tab bar
        border: null, // Remove the top border
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8), // Add padding above the icon
              child: Icon(CupertinoIcons.repeat),
            ),
            label: 'Habit',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(CupertinoIcons.list_bullet),
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(CupertinoIcons.hourglass),
            ),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(CupertinoIcons.square_grid_2x2),
            ),
            label: 'More',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => HabitsPage());
          case 1:
            return CupertinoTabView(builder: (context) => TasksPage());
          case 2:
            return CupertinoTabView(builder: (context) => FocusPage());
          case 3:
            return CupertinoTabView(builder: (context) => MorePage());
          default:
            return CupertinoTabView(builder: (context) => TasksPage());
        }
      },
    );
  }
}
