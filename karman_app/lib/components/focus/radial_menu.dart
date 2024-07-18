import 'dart:math';
import 'package:flutter/cupertino.dart';

class RadialMenu extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onItemSelected;
  final String? currentSound;
  final VoidCallback onDismiss;

  const RadialMenu({
    Key? key,
    required this.items,
    required this.onItemSelected,
    required this.onDismiss,
    this.currentSound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: CupertinoColors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevents taps on the menu itself from dismissing
            child: Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < items.length; i++)
                    _buildMenuItem(context, i),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, int index) {
    final double angle = 2 * pi / items.length * index - pi / 2;
    final double radius = 110;
    final double x = cos(angle) * radius;
    final double y = sin(angle) * radius;

    final item = items[index];
    final isSelected = item['file'] == currentSound;

    return Positioned(
      left: 140 + x - 30,
      top: 140 + y - 30,
      child: GestureDetector(
        onTap: () {
          onItemSelected(item);
          onDismiss();
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? CupertinoColors.activeBlue
                : CupertinoColors.darkBackgroundGray,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            item['icon'],
            color: CupertinoColors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
