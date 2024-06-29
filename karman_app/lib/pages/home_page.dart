import 'package:flutter/material.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Zen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
