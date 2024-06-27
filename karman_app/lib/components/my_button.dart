import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Color color;
  VoidCallback onPressed;

  MyButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: onPressed,
      color: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
