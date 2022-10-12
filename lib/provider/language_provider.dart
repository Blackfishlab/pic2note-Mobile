//
// language_provider.dart
//

// Flutter imports
import 'package:flutter/material.dart';

// Local imports
import '../helper/globals.dart';

class LanguageProvider extends ChangeNotifier {

  // Local var representing selected language
  String? _selectedLanguage;
 
  LanguageProvider() {
    _selectedLanguage = 'en';
    readPreferences();
  }
 
  // Return selected language
  Locale get selectedLanguage => Locale(_selectedLanguage!); 
  
  // Save selected language to shared preferences
  void changeLanguage(String _languageSelected) {

    _selectedLanguage = _languageSelected;
    Globals.sharedPref?.setString(Globals.lang, _languageSelected);

    notifyListeners();
  }

  // Procedure to read selected language from shared preferences
  readPreferences() {
    
    // Read selecred language from Shared Preferences
    String? _tmpSelectedLanguage = Globals.sharedPref?.getString(Globals.lang);

    // If value from shared preferences is not null update selected language variable
    _selectedLanguage = _tmpSelectedLanguage ?? _selectedLanguage;

    notifyListeners();
  }

}