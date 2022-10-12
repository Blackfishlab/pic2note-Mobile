//
// picnote_provider.dart
//

// Dart imports
import 'dart:io';

// Flutter imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Class that provides info on picnote list
class PicNoteProvider with ChangeNotifier {


  // Local vars
  int _notesCount = 0;

  int get notesCount {
    return _notesCount;
  }

  //
  // Delete PicNote
  //
  void deletePicNote(String noteId, String userId) async {
    
    // Delete image file @ Storage
    final imageFileRef = FirebaseStorage.instance.ref().child('note_images').child(userId).child(noteId + '.jpeg');
    await imageFileRef.delete().whenComplete(() => null);
    
    // Delete picNote @ Firestore
    await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();

    notifyListeners();
  }

  //
  // Add PicNote
  //
  void addPicNote (String uId, String title, String note, File picFile) async { 
    
    // Create new document @ Cloud Firestore and get document ID
    DocumentReference docRef = FirebaseFirestore.instance.collection('notes').doc();
    String docId = docRef.id; 

    // Save image to Firebase Storage
    final ref = FirebaseStorage.instance.ref().child('note_images').child(uId).child(docId + '.jpeg');
    await ref.putFile(picFile).whenComplete(() => null);
    final picUrl = await ref.getDownloadURL();
    
    // Save note data to Cloud Firestore
    FirebaseFirestore.instance.collection('notes').doc(docId).set({
      'noteId': docId,
      'userId': uId,
      'title': title,
      'note': note,
      'pic' : picUrl,
      'date': Timestamp.now(),
    }).then((value) => null);

    notifyListeners();
  }

  //
  // Update PicNote
  //
  void updatePicNote (String uId, String noteId, String title, String note, File picFile) async {
  
    // Check if we have a new picture
    if (picFile.path != '') {
      
      // New picture
      // First delete cutternt image @ Firebase Storage  
      final imageFileRef = FirebaseStorage.instance.ref().child('note_images').child(uId).child(noteId + '.jpeg');
      await imageFileRef.delete().whenComplete(() => null);
      
      // Then save new image to Firebase Storage
      await imageFileRef.putFile(picFile).whenComplete(() => null);
      final picUrl = await imageFileRef.getDownloadURL();
      
      // Then update Firebase Firestore
      await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
        'title': title,
        'note': note,
        'pic' : picUrl,
        'date': Timestamp.now(),
      });
    } else {
      // No new picture
      // Update Firebase Firestore
      await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
        'title': title,
        'note': note,
        'date': Timestamp.now(),
      });
    
    }
    notifyListeners();
  }

  //
  // Get number of PicNotes for a given user
  //
  void getNumberOfNotes(uId) async {
    
    final qS = await FirebaseFirestore.instance.collection('notes').where('userId', isEqualTo: uId).get();
    _notesCount = qS.docs.length;

    notifyListeners();
   
    
  }

}