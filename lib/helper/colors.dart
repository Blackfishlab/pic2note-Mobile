//
// ./helper/colors.dart
//

// Flutter imports
import 'package:flutter/material.dart';

// Global color definitions
class AppColors {
    
    // Colors used for note background in note_screen and note_screen_view
    static Color? noteBackgroundLight = Colors.yellow[50];
    static Color? noteBackgroundDark = Colors.grey[700];

    // Text color in bottom app bar
    static Color? bottomABColor = Colors.white;

    // Color used for borders in note_screen and note_screen_view
    static Color border = Colors.grey;
}

// Palette defnition for swatch
class Palette { 
  static const MaterialColor colors = MaterialColor( 
    0xff1d9e3e,
    <int, Color>{ 
      50: Color(0xff1a8e38),//10% 
      100: Color(0xff177e32),//20% 
      200: Color(0xff146f2b),//30% 
      300: Color(0xff115f25),//40% 
      400: Color(0xff0f4f1f),//50% 
      500: Color(0xff0c3f19),//60% 
      600: Color(0xff092f13),//70% 
      700: Color(0xff06200c),//80% 
      800: Color(0xff031006),//90% 
      900: Color(0xff000000),//100% 
    }, 
  ); 
}