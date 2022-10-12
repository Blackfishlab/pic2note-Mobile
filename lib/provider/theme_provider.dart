//
// theme_provider.dart
//

// Flutter imports
import 'package:flutter/material.dart';

// Local imports
import '../helper/globals.dart';

class ThemeProvider extends ChangeNotifier {

  // Local var representing Is dark mode selected or not
  bool? _darkMode;
 
  ThemeProvider() {
    _darkMode = false;
    readPreferences();
  }
 
  // Return bool value of Dark Mode
  bool get isDarkModeOn => _darkMode!; 
  
  // Save bool value of Dark Mode to Shared Preferences
  void changeTheme(bool _isDarkModeOn) {

    _darkMode = _isDarkModeOn;
    Globals.sharedPref?.setBool(Globals.darkModeOn, _isDarkModeOn);
    
    notifyListeners();
  }

  // Procedure to read Darm Mode from shared preferences
  readPreferences() {
    
    // Read Dark Mode from  Shared Preferences
    bool? _tmpDarkMode = Globals.sharedPref?.getBool(Globals.darkModeOn);
    
    // If value from shared preferences is not null update dark mode variable
    _darkMode = _tmpDarkMode ?? _darkMode;

    notifyListeners();
  }

}