import 'package:flutter/cupertino.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideToAct extends StatelessWidget {
  const SlideToAct({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      innerColor: CupertinoColors.white,
      outerColor: CupertinoColors.systemGrey,
      sliderButtonIcon: Icon(
        CupertinoIcons.circle_grid_hex,
        color: CupertinoColors.black,
      ),
      sliderRotate: false,
      elevation: 0,
      text: 'Complete your habit',
      textColor: CupertinoColors.black,
      onSubmit:
          () {}, // need to save the habit and lock the habit tile from further editing
    );
  }
}
