//
// main.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Local imports
import 'package:pic2note/pic2noteapp.dart';
import 'package:pic2note/provider/picnote_provider.dart';
import 'package:pic2note/provider/auth_provider.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/provider/language_provider.dart';
import 'package:pic2note/helper/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize shared preferences
  await Globals.sharedPrefInit();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PicNoteProvider>(create: (BuildContext context){
          return PicNoteProvider();
        }),
        ChangeNotifierProvider<AuthProvider>(create: (BuildContext context){
          return AuthProvider();
        }),
        ChangeNotifierProvider<ThemeProvider>(create: (BuildContext context){
          return ThemeProvider();
        }),
        ChangeNotifierProvider<LanguageProvider>(create: (BuildContext context){
          return LanguageProvider();
        }),
      ],
      child: const Pic2NoteApp(),
    ),
  );
}



