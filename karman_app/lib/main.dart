import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:karman_app/data/database.dart';
import 'package:karman_app/pages/home_page.dart';

void main() async {
  // init hive
  await Hive.initFlutter();

  // open the box
  var box = await Hive.openBox('myBox');

  KarmanDataBase db = KarmanDataBase();
  if (box.get('folders') == null) {
    db.createInitialData();
    db.updateDatabase();
  } else {
    db.loadData();
  }

  runApp(KarmanApp(db: db));
}

class KarmanApp extends StatelessWidget {
  final KarmanDataBase db;

  const KarmanApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(db: db),
    );
  }
}
