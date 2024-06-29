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
        title: const Text('Zen'),
      ),
      body: const Placeholder(),
    );
  }
}
