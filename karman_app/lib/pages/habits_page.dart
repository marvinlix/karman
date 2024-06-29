import 'package:flutter/material.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
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
              'Habits Page',
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
