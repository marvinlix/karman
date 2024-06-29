import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Pomodoro Page',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    );
  }
}
