//
// ./screen/password_reset_screen.dart
//

// Flutter imports
import 'package:flutter/material.dart';

// Local imports
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  static const routeName = 'password_reset_screen';

  const PasswordResetScreen({ Key? key }) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Function executed after form is submitted
  _submitForm(){
    if (!_formKey.currentState!.validate()) {
      // Invalid input!
      return;
    }
    //
    _formKey.currentState!.save();

    // Show snackbar after delete
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate('passwordResetScreenSnack')),
      ),
    );

    // Close screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('passwordResetScreenTitle')),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Expanded(
                          child: Text(
                            AppLocalizations.of(context).translate('passwordResetScreenMessage'),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('passwordResetScreenTextLabel'),
                                prefixIcon: const Icon(Icons.alternate_email),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return AppLocalizations.of(context).translate('passwordResetScreenTextError');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                Provider.of<AuthProvider>(context, listen: false).passwordReset(value!);
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(203, 48),
                              ),
                              onPressed: _submitForm,
                              child: Text(
                                AppLocalizations.of(context).translate('passwordResetScreenButton'),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
        
      );
  }
}