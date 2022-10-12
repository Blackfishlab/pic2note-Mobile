//
// routes.dart
//

// Local imports
import 'package:pic2note/screen/splash_screen.dart';
import 'package:pic2note/screen/main_screen.dart';
import 'package:pic2note/screen/note_screen.dart';
import 'package:pic2note/screen/auth_screen.dart';
import 'package:pic2note/screen/settings_screen.dart';
import 'package:pic2note/screen/note_screen_view.dart';
import 'package:pic2note/screen/password_reset_screen.dart';

// Route definitions
getRoutes() {
  return {
    MainScreen.routeName: (context) => const MainScreen(),
    SplashScreen.routeName: (context) => const SplashScreen(),
    NoteScreen.routeName: (context) => const NoteScreen(),
    AuthScreen.routeName: (context) => AuthScreen(),
    SettingsScreen.routeName: (context) => const SettingsScreen(),
    NoteScreenView.routeName: (context) => const NoteScreenView(),
    PasswordResetScreen.routeName: (context) => const PasswordResetScreen(),
  };
}
