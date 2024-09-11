import 'package:flutter/cupertino.dart';

class MinimalFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const MinimalFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 24, bottom: 24),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: CupertinoColors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
