import 'package:hive/hive.dart';

class KarmanDataBase {
  List taskList = [];

  // reference to the database
  final _myBox = Hive.box('myBox');

  // Run this function to create initial data when the app is first installed
  void createIntialData() {
    taskList = [
      ['Welcome to Karman', false],
      ['Add a new task', false],
      ['Swipe left to edit or delete', false],
      ['Tap to mark as completed', false],
      ['Share with friends', false],
      ['Enjoy!', false],
    ];
  }

  // Load data from the database
  void loadData() {
    taskList = _myBox.get('tasks', defaultValue: taskList);
  }

  // Update the database with the new data
  void updateDataBase() {
    _myBox.put('tasks', taskList);
  }
}
