import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:karman_app/data/database.dart';
import 'package:karman_app/pages/habits_page.dart';
import 'package:karman_app/pages/pomodoro_page.dart';
import 'package:karman_app/pages/settings_page.dart';
import 'package:karman_app/pages/tasks_page.dart';
import 'package:karman_app/pages/zen_page.dart';

class HomePage extends StatefulWidget {
  final KarmanDataBase db;

  const HomePage({
    super.key,
    required this.db,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  // Tasks related variables
  String _selectedFolderName = '';

  // Habits related variables

  // Pomodoro related variables

  // Zen related variables

  @override
  void initState() {
    super.initState();
    widget.db.loadData();
    _selectedFolderName = widget.db.folders.keys.first;
    _pages = [
      TasksPage(folderName: _selectedFolderName, db: widget.db),
      HabitsPage(),
      PomodoroPage(),
      ZenPage(),
      SettingsPage(),
    ];
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: GNav(
          backgroundColor: Colors.black,
          activeColor: Colors.white,
          color: Colors.white,
          tabBackgroundColor: Colors.grey.shade900,
          gap: 8,
          padding: EdgeInsets.all(10),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconSize: 30,
          haptic: true,
          tabs:  const [
            GButton(
              icon: Icons.list,
              text: 'Tasks',
            ),
            GButton(
              icon: Icons.check,
              text: 'Habits',
            ),
            GButton(
              icon: Icons.timer,
              text: 'Pomodoro',
            ),
            GButton(
              icon: Icons.self_improvement,
              text: 'Zen',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }
}
