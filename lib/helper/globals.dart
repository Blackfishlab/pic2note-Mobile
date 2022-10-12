//
// ./helper/globals.dart
//
// Stores global avriables using shared preferences

// Flutter imports
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  
  static SharedPreferences? sharedPref;

  // Declare keys for Shared Preferences
  static String darkModeOn = 'darkModeOn';
  static String lang = 'lang';
  static String test = 'test';
  static String email = 'email';
  static String uid = 'uId';
  static String expDat = 'loginExpiryDate';

  static Future sharedPrefInit() async {
    sharedPref = await SharedPreferences.getInstance();
  }

}