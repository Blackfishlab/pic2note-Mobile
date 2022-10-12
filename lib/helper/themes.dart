//
// ./helper/themes.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:pic2note/helper/fonts.dart';

// Local imports
import './colors.dart';
import './fonts.dart';

class AppThemes {
  
  //the light theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: AppFonts.roboto,
    primarySwatch: Palette.colors,
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(203, 36),
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
    ),
  
  );

  //the dark theme
  static final ThemeData darkTheme = ThemeData(
    fontFamily: AppFonts.roboto,
    primarySwatch: Palette.colors,
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(203, 36),
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
    ),
  );
}