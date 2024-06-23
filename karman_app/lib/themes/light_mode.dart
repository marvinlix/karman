/* 
  LIGHT MODE:
    Color Scheme:
      - primary color: #F0F0F0
      - secondary color: #E0E0E0
      - background color: #FFFFFF
      - text color: #000000
    Tags:
      - Red: #D32F2F (Darker Red)
      - Orange: #F57C00 (Darker Orange)
      - Yellow: #FBC02D (Darker Yellow)
      - Green: #388E3C (Darker Green)
      - Blue: #1976D2 (Darker Blue)
      - Purple: #7B1FA2 (Darker Purple)

  DARK MODE:
    Color Scheme:
      - primary color: #303030
      - secondary color: #404040
      - background color: #000000
      - text color: #FFFFFF
    Tags:
      - Red: #FF5252 (Lighter Red)
      - Orange: #FFAB40 (Lighter Orange)
      - Yellow: #FFEB3B (Lighter Yellow)
      - Green: #69F0AE (Lighter Green)
      - Blue: #40C4FF (Lighter Blue)
      - Purple: #B388FF (Lighter Purple)
*/

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey[100]!,
    secondary: Colors.grey[200]!,
    background: Colors.white,
  ),
);

