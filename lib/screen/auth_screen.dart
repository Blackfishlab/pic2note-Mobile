//
// ./screen/auth_screen.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// Local imports
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/provider/auth_provider.dart';
import 'package:pic2note/screen/password_reset_screen.dart';
import 'package:pic2note/widget/modalmessagewindow.dart';

import '../helper/colors.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth_screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  // Local vars
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  String? emailInput;
  String? passwordInput;
  String? confirmPasswordInput;
  int tabIndex = 0;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };   
  
  @override
  Widget build(BuildContext context) {
    
    // Calculate top height between 
    final topHeight = ((MediaQuery.of(context).size.height - 639)/2).toDouble();

    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.noteBackgroundLight,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: topHeight),
                Container(
                  child: Image.asset('assets/images/splash_yellow.jpg', height: 150, width: 150),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context).translate('authScreenMessage'),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    //color: Colors.amber,
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.login),
                          text: AppLocalizations.of(context).translate('authScreenLoginTab'),
                        ),
                        Tab(
                          icon: Icon(Icons.app_registration),
                          text: AppLocalizations.of(context).translate('authScreenRegisterTab'),
                        ),
                      ],
                      onTap:(tabNo) {
                        if(tabNo == 0){
                          // Login
                          tabIndex = 0;
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          // Register
                          tabIndex = 1;
                          _emailController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();  
                        }
                      },
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        //color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )                    
                  )
                ),
                Container(
                  height: 379,
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).isDarkModeOn ? Theme.of(context).backgroundColor : Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(8.0), 
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: [
                            Form(
                              key: _loginFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).translate('authScreenEmailLabel'),
                                        prefixIcon: Icon(Icons.alternate_email),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return AppLocalizations.of(context).translate('authScreenEmailError');
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['email'] = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).translate('authScreenPasswordLabel'),
                                        prefixIcon: const Icon(Icons.password),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            // Toggle show / hide password text
                                            setState(() {
                                              _hidePassword = !_hidePassword;
                                            });
                                          },
                                          // Display icon based on show / hide password text
                                          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                                        )
                                      ),
                                      obscureText: _hidePassword,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 5) {
                                          return AppLocalizations.of(context).translate('authScreenPasswordError');
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['password'] = value!;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: _registerFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).translate('authScreenEmailLabel'),
                                        prefixIcon: Icon(Icons.alternate_email),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return AppLocalizations.of(context).translate('authScreenEmailError');
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['email'] = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).translate('authScreenPasswordLabel'),
                                        prefixIcon: const Icon(Icons.password),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            // Toggle show / hide password text
                                            setState(() {
                                              _hidePassword = !_hidePassword;
                                            });
                                          },
                                          // Display icon based on show / hide password text
                                          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                                        )
                                      ),
                                      obscureText: _hidePassword,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 5) {
                                          return AppLocalizations.of(context).translate('authScreenPasswordError');
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['password'] = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).translate('authScreenPasswordConfirmLabel'),
                                        prefixIcon: const Icon(Icons.password),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            // Toggle show / hide password text
                                            setState(() {
                                              _hideConfirmPassword = !_hideConfirmPassword;
                                            });
                                          },
                                          // Display icon based on show / hide password text
                                          icon: Icon(_hideConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                        )
                                      ),
                                      obscureText: _hideConfirmPassword,
                                      controller: _confirmPasswordController,
                                      validator: (value) {
                                        if (value != _passwordController.text) {
                                          return AppLocalizations.of(context).translate('authScreenPasswordConfirmError');
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                      },
                                    ),
                                  ),                            
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          submitLoginForm();
                        }, 
                        child: Text(AppLocalizations.of(context).translate('authScreenButton1'))
                      ),
                      TextButton(
                        onPressed: (){
                          // Go to password_reset_screen
                          Navigator.of(context).pushNamed(PasswordResetScreen.routeName);                    
                        }, 
                        child: Text(AppLocalizations.of(context).translate('authScreenButton2')),
                      )    
                    ],
                  ),
                ),
              ],  
            ),
          ),
        ),
      ),
    );

  }

  submitLoginForm() async{

    // Login / register return values
    String _uId = '';
    String _error = '';

    // Check form validity
    if(tabIndex == 0){

      // Login form check
      if (!_loginFormKey.currentState!.validate()) {
          // Invalid!
          return;
      }

      // If form is valid execute save
      _loginFormKey.currentState!.save();

    } else {
      
      // Register form check
      if (!_registerFormKey.currentState!.validate()) {
        // Invalid!
        return;
      }

      // If form is valid execute save
      _registerFormKey.currentState!.save();

    }

    try {
    
      if(tabIndex == 0){
        // Login selected
        await Provider.of<AuthProvider>(context, listen: false).login(_authData['email']!, _authData['password']!).then((value){
          _uId = value['uId']!;
          _error = value['error']!;
        });
      } else {
        // Register selected
        await Provider.of<AuthProvider>(context, listen: false).register(_authData['email']!, _authData['password']!).then((value){
          _uId = value['uId']!;
          _error = value['error']!;
        });
      }

      // Handle no network connection
      if(_uId == '' && _error == ''){
        String errorMessage = AppLocalizations.of(context).translate('authScreenErrorMessage');
        _showErrorDialog(errorMessage);
      } 
      

      if(_error != ''){
        print('------------- Error 1');
        switch (_error) {
           case  'user-not-found': {
            _error = AppLocalizations.of(context).translate('authProviderNoUser');
          }
          break;
          case 'wrong-password': {
            _error = AppLocalizations.of(context).translate('authProviderWrongPassword');
          }
          break;
          case 'weak-password': {
            _error = AppLocalizations.of(context).translate('authProviderWeakPassword');
          }
          break;
          case 'email-already-in-use': {
            _error = AppLocalizations.of(context).translate('authProviderAccountExists');
          }
          break;
          default: {
            _error = AppLocalizations.of(context).translate('authProviderUnknown');
          }
          break;
        }
        _showErrorDialog(_error);
      }


    } catch (error){
              print('------------- Error 2');
    String errorMessage = AppLocalizations.of(context).translate('authScreenErrorMessage');
    _showErrorDialog(errorMessage);
  }


  }

  // Error message dialog
  void _showErrorDialog(String message){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: modalMessageWindowBuilder(
        title: AppLocalizations.of(context).translate('authScreenDialogText'),
        message: message,
        button0: AppLocalizations.of(context).translate('authScreenDialogButton'),
      )
    );
  }


}



