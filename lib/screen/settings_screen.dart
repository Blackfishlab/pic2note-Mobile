//
// ./screen/settings_screen.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local imports
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/provider/language_provider.dart';
import 'package:pic2note/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  static String routeName = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settingsScreenTitle')),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('settingsScreenDarkTitle')),
                  subtitle: Text(AppLocalizations.of(context).translate('settingsScreenDarkSubtitle')),
                  trailing: Switch(
                    value: Provider.of<ThemeProvider>(context).isDarkModeOn,
                    onChanged: (bool boolState){
                      Provider.of<ThemeProvider>(context, listen: false).changeTheme(boolState);
                    },
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('settingsScreenLanguageTitle')),
                  subtitle: Text(AppLocalizations.of(context).translate('settingsScreenLanguageSubtitle')),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.language),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        //enabled: true,
                        enabled: Provider.of<LanguageProvider>(context, listen: false).selectedLanguage == const Locale('hr') ? true : false,
                        child: Text(AppLocalizations.of(context).translate('settingsScreenLanguage1')),
                        onTap: (){
                          Provider.of<LanguageProvider>(context, listen: false).changeLanguage('en');
                        },
                      ),
                      PopupMenuItem(
                        //enabled: true,
                        enabled: Provider.of<LanguageProvider>(context, listen: false).selectedLanguage == const Locale('en') ? true : false,
                        child: Text(AppLocalizations.of(context).translate('settingsScreenLanguage2')),
                        onTap: (){
                          Provider.of<LanguageProvider>(context, listen: false).changeLanguage('hr');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child:  ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(203, 36),
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate('settingsScreenButton'),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}