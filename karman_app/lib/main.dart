import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:karman_app/pages/tasks_page.dart';

void main() async{
  // init hive
  await Hive.initFlutter();
  
  // open the box
  var box = await Hive.openBox('myBox');

  runApp(const KarmanApp());
}

class KarmanApp extends StatelessWidget {
  const KarmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasksPage(),
    );
  }
}
