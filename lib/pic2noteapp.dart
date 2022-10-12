//
// pic2noteapp.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Local imports
import 'package:pic2note/screen/auth_screen.dart';
import 'package:pic2note/screen/main_screen.dart';
import 'package:pic2note/routes.dart';
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/helper/themes.dart';
import 'package:pic2note/provider/language_provider.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/provider/auth_provider.dart';


class Pic2NoteApp extends StatelessWidget {
  const Pic2NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, ThemeProvider themeProvider, child) {
        return Consumer<LanguageProvider>(
          builder: (context, LanguageProvider languageProvider, child) {
            return Consumer<AuthProvider>(
              builder: (context, AuthProvider authProvider, child){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'pic2note',
                  theme: AppThemes.lightTheme,
                  darkTheme: AppThemes.darkTheme,
                  themeMode:
                      themeProvider.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
                  locale: languageProvider.selectedLanguage,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: const [Locale('en', ''), Locale('hr', '')],
                  home: authProvider.userAuthenticated ? MainScreen() :  AuthScreen(),
                  routes: getRoutes(),
                );
              }
            );
          }
        );
      }
    );
  }
}

