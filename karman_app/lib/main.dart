import 'package:flutter/material.dart';

void main() {
  runApp(const KarmanApp());
}

class KarmanApp extends StatelessWidget {
  const KarmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karman',
    );
  }
}
