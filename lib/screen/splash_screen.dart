//
// ./screen/splash_screen.dart
//

// Dart imports
import 'dart:math' as math;

// Flutter imports
import 'package:flutter/material.dart';

// Local imports
import 'package:pic2note/screen/auth_screen.dart';
import 'package:pic2note/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  static String routeName = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[50],
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.asset('assets/images/splash_yellow.jpg',),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: const Offset(7, 8),
                  )
                ],
              ),
            ),
            Transform.rotate(
              angle: -12.068573243858582 * (math.pi / 300),
              child: Text(
                AppLocalizations.of(context).translate('splashScreenTitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'RougeScript',
                  fontSize: 96,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, AuthScreen.routeName);
              },
              child: Text(
                AppLocalizations.of(context).translate('splashScreenButton'),
              ),
            ),
          ]
        ),
        ), 
    );
  }
}

