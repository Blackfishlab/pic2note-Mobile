//
// picnote_provider.dart
//

// Dart imports
import 'dart:async';

// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Local imports
import 'package:pic2note/helper/config.dart';
import '../helper/globals.dart';

class AuthProvider with ChangeNotifier {

  // Local vars
  DateTime? _expiryDate;
  String? _email;

  // Timer for expiry date
  Timer? _authTimer;

  // Connect to Firebase Auth
  final _auth = FirebaseAuth.instance;

  //
  // Return true if user is authenticated against firebase -- isAuth
  //
  bool get userAuthenticated {
    if(_auth.currentUser != null){
      return true;
    }else{
      return false;
    }
  }

  //
  // Log in user
  // Returns user id and error message
  //
  Future<Map<String, String>> login(String email, String password) async {
    // Map for return data
    Map<String, String> _response = {'uId': '', 'error': ''};
    // Local vars
    String _uId = '';
    String _error = '';
    UserCredential _authResult;

    try {
      _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      _uId = _authResult.user!.uid;
      _email = _authResult.user!.email;

      // User login expires in Config.userLoginExpiryPeriod seconds
      _expiryDate = DateTime.now().add(Duration(seconds: Config.userLoginExpiryPeriod));
      
      // Save user data to shared preferences
      Globals.sharedPref?.setString(Globals.uid, _authResult.user!.uid);
      Globals.sharedPref?.setString(Globals.email, _authResult.user!.email!);
      Globals.sharedPref?.setString(Globals.expDat, _expiryDate!.toIso8601String());

    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        _error = 'user-not-found';
      } else if (error.code == 'wrong-password') {
        _error = 'wrong-password';
      }
    } catch (error) {
      _error = 'Error.';
    }
    _response['uId'] = _uId;
    _response['error'] = _error;

    // Call auto logout to set timer
    _autoLogout();

    // Notify listeners
    notifyListeners();

    return _response;
  }

  //
  //  Auto Login
  //
  void autoLogin() async {
    
    //If user id exists in shared preferences, user has been logged in before
    if(Globals.sharedPref?.getString(Globals.uid) != null){
      // Restore auto-logout timer
      _expiryDate = DateTime.parse((Globals.sharedPref?.getString(Globals.expDat))!);

      // Call auto logout to set timer
      _autoLogout();
    }
  }

  //
  // Register new user
  // Returns user id and error message
  //
  Future<Map<String, String>> register(String email, String password) async {
    // Map for return data
    Map<String, String> _response = {'uId': '', 'error': ''};
    // Local vars
    String _uId = '';
    String _error = '';
    UserCredential _authResult;

    try {
      _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _uId = _authResult.user!.uid;

      // Save user data to Cloud Firestore
      await FirebaseFirestore.instance.collection('users').doc(_uId).set({
        'userId': _uId,
        'userEmail': email,
      });

      // User login expires in Config.userLoginExpiryPeriod seconds
      _expiryDate = DateTime.now().add(Duration(seconds: Config.userLoginExpiryPeriod));

      // Save user data to shared preferences
      Globals.sharedPref?.setString(Globals.uid, _authResult.user!.uid);
      Globals.sharedPref?.setString(Globals.email, _authResult.user!.email!);
      Globals.sharedPref?.setString(Globals.expDat, _expiryDate!.toIso8601String());

    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        _error = 'weak-password';
      } else if (error.code == 'email-already-in-use') {
        _error = 'email-already-in-use';
      }
    } catch (error) {
      _error = 'Error.';
    }
    _response['uId'] = _uId;
    _response['error'] = _error;

    // Call auto logout to set timer
    _autoLogout();

    // Notify listeners
    notifyListeners();

    return _response;
  }

  //
  // Delete user
  // Returns user id and error message
  //
  Future<void> deleteUser(String userId) async {
    // Delete all account images from Storage

    // Delete all account notes from Firestore notes collection
    var pic2NoteCollection = FirebaseFirestore.instance.collection('notes');
    var pic2NoteSnapshots =
        await pic2NoteCollection.where('userId', isEqualTo: userId).get();
    for (var pic2NoteDoc in pic2NoteSnapshots.docs) {
      final imageFileRef = FirebaseStorage.instance
          .ref()
          .child('note_images')
          .child(userId)
          .child(pic2NoteDoc['noteId'] + '.jpeg');
      await imageFileRef.delete().whenComplete(() => null);
      pic2NoteDoc.reference.delete();
    }

    // Delete account info from Firestore users collection
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();

    // Delete user account form Firebase
    User? user = _auth.currentUser;
    user!.delete();

    // Notify listeners
    notifyListeners();

  }

  //
  // Logout
  //
  Future<void> logout() async {

    await _auth.signOut().then((value) {

      // Clear user data to shared preferences
      Globals.sharedPref?.setString(Globals.uid, null.toString());
      Globals.sharedPref?.setString(Globals.email, null.toString());
      Globals.sharedPref?.setString(Globals.expDat, null.toString());

      // Notify listeners
      notifyListeners();

    });

  }

  //
  // Password reset
  // Send password reset email
  //
  Future<void> passwordReset(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }


  //
  // Auto-logout function
  //
  void _autoLogout() async {

    // If there is existing timer
    if(_authTimer != null) {
      // Cancel it
      _authTimer!.cancel();
    }

    // Calculate time to expiry: _expiryDate - now
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    
    // Set and store timer
    _authTimer = Timer(Duration(seconds: timeToExpiry), await logout);
  }
}
