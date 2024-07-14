import 'package:flutter/cupertino.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Foucs'),
      ),
      child: Center(
        child: Text('Focus Page'),
      ),
    );
  }
}
