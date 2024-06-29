import 'package:flutter/material.dart';

class ZenPage extends StatefulWidget {
  const ZenPage({super.key});

  @override
  State<ZenPage> createState() => _ZenPageState();
}

class _ZenPageState extends State<ZenPage> {
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
              'Zen Page',
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
