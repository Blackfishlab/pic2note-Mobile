//
// ./screen/note_screen.dart
//

// Dart imports
import 'dart:io';

// Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Local imports
import 'package:pic2note/provider/picnote_provider.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/helper/colors.dart';
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/widget/modalmessagewindow.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  static String routeName = 'note_screen';

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String _title = '';
  String? _noteId;
  String notePic = '';
  File _picFile = File('');
  String _uId = '';

  // CollectionReference to Firestore 'notes' collection
  CollectionReference pic2NoteColRef = FirebaseFirestore.instance.collection('notes');

  DocumentSnapshot? picNoteDoc;

  // Vars for routing arguments
  bool? isEdit; // True if editing note, false if adding note
  String? noteId;

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 600, imageQuality: 50);
    if (imageFile!.path == '') {
      return;
    }
    setState(() {
      _picFile = File(imageFile.path);
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Get routing argument(s)
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    picNoteDoc = arguments['document'];
    _uId = arguments['userId'];

    // Check if we are in Edit or Add mode
    if (picNoteDoc != null) {
      // Edit mode
      isEdit = true;
      _title = AppLocalizations.of(context).translate('noteScreenTitle2');
      _noteId = picNoteDoc!['noteId'];
      _titleController.text = picNoteDoc!['title'];
      _noteController.text = picNoteDoc!['note'];
      notePic = picNoteDoc!['pic'];
    } else {
      // Add mode
      isEdit = false;
      _title = AppLocalizations.of(context).translate('noteScreenTitle1');
    }

    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    // if Edit mode...
                    if (isEdit == true)
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColors.border),
                        ),
                        child: _picFile.path == ''
                            ? CachedNetworkImage(
                                imageUrl: picNoteDoc!['pic'],
                                width: 200,
                                height: 200,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.file(_picFile,
                                width: 200, height: 200, fit: BoxFit.fill),
                      ),

                    // If Add mode...
                    if (isEdit == false)
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColors.border),
                        ),
                        child: _picFile.path != ''
                            ? Image.file(_picFile,
                                width: 200, height: 200, fit: BoxFit.fill)
                            : const Icon(Icons.photo),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.camera),
                      label: Text(AppLocalizations.of(context)
                          .translate('noteScreenPictureLabel')),
                      onPressed: () {
                        _takePicture();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('noteScreenTitleLabel'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PhysicalModel(
                      color: (Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight)!,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(

                        child: TextField(
                          controller: _titleController,
                        ),
                      ),
                    ),                    
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('noteScreenNoteLabel'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PhysicalModel(
                      color: (Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight)!,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(5),                      
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          controller: _noteController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(203, 48),
            ),
            onPressed: () {
              if ((_picFile.path != '' || picNoteDoc?['pic'] != null) &&
                  _titleController.text != '') {
                // If we have existing pictue or new picture was taken and Text field is not empty
                if (isEdit!) {
                  // Edit mode
                  Provider.of<PicNoteProvider>(context, listen: false)
                      .updatePicNote(_uId, _noteId!, _titleController.text,
                          _noteController.text, _picFile);
                } else {
                  // Add mode
                  Provider.of<PicNoteProvider>(context, listen: false)
                      .addPicNote(_uId, _titleController.text,
                          _noteController.text, _picFile);
                }
                Navigator.of(context).pop();
              } else {
                // Show dialog Missing data
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: modalMessageWindowBuilder(
                    title: AppLocalizations.of(context).translate('noteScreenMissingTitle'),
                    message: AppLocalizations.of(context).translate('noteScreenMissingContent'),
                    button0: AppLocalizations.of(context).translate('noteScreenMissingOk'),
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context).translate('noteScreenButton'),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
