import 'package:hive/hive.dart';

class KarmanDataBase {
  Map<String, List> folders = {};

  // Reference to the database
  final _myBox = Hive.box('myBox');

  // Run this function to create initial data when the app is first installed
  void createInitialData() {
    folders = {
      'General': [
        ['Welcome to Karman', false],
        ['Add a new task', false],
        ['Swipe left to edit or delete', false],
        ['Tap to mark as completed', false],
        ['Share with friends', false],
        ['Enjoy!', false],
      ],
    };
  }

  // Load data from the database
  void loadData() {
    folders = Map<String, List>.from(_myBox.get('folders', defaultValue: folders));
  }

  // Update the database with the new data
  void updateDatabase() {
    _myBox.put('folders', folders);
  }
}
