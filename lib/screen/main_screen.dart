//
// ./screen/main_screen.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Local imports
import 'package:pic2note/screen/note_screen.dart';
import 'package:pic2note/screen/settings_screen.dart';
import 'package:pic2note/provider/auth_provider.dart';
import 'package:pic2note/screen/auth_screen.dart';
import 'package:pic2note/provider/picnote_provider.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/screen/note_screen_view.dart';
import 'package:pic2note/helper/colors.dart';
import 'package:pic2note/helper/functions.dart';
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/widget/modaldialogwindow.dart';
import '../helper/globals.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  // Route name
  static String routeName = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  // Local vars
  // User id
  String? _uId;
  // User email
  String? _email;
  // Shwitch showing if user is logged in
  bool isLoggedIn = false;
  // Date format
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm"); 
  
  // CollectionReference to Firestore 'notes' collection
  CollectionReference pic2NoteColRef = FirebaseFirestore.instance.collection('notes');

  // List of document snapshots for logged
  List<DocumentSnapshot> _usrPic2Note = [];
  
  // Note count to show on screen
  String noteCount = '';

  // Function to update note count on screen 
  void updateNoteCount(String nc){
    setState(() {
      noteCount = nc;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      
      // Call Auto Login function at start
      Provider.of<AuthProvider>(context, listen: false).autoLogin();
    
    });
  }

  @override
  Widget build(BuildContext context) {

    // Get user id and email from shared preferences
    _email = Globals.sharedPref?.getString(Globals.email);
    _uId = Globals.sharedPref?.getString(Globals.uid);
  
    // Switch - shows currently selected theme brithness mode
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkModeOn;
    // Execute provider function to get number of notes for given user
    Provider.of<PicNoteProvider>(context).getNumberOfNotes(_uId);

    return Scaffold (
      // App bar
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('mainScreenTitle')),
        actions: <Widget>[
          // Show logged user initials avatar
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Consumer<AuthProvider>(
              builder: (context, AuthProvider authProvider, child){
                 return CircleAvatar(
                  //child: const Icon(Icons.account_circle_outlined),
                  
                  // Prepare content for circla avatar
                  //child: Text(Functions.getInitials(Globals.sharedPref?.getString(Globals.email))),
                  child: Text(Functions.getInitials(_email)),
                );
              }
            ), 
          ),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          // Set color of Container based on brightness mode
          color: isDarkMode ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<PicNoteProvider>(
              builder: (context, PicNoteProvider picnoteProvider, child){
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('mainScreenBottomNav') + picnoteProvider.notesCount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.bottomABColor,
                    ),
                  ),
                );
              }
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                child: InkWell(
                  onTap:(){
                    // When user taps on + load add niote screen
                    Navigator.pushNamed(context, NoteScreen.routeName,
                      arguments: {
                        'document': null,
                        'userId': _uId,
                      }
                    );
                  },
                  child: Icon(Icons.add, color: AppColors.bottomABColor, size: 32.0),
                  splashColor: AppColors.bottomABColor,
                ),
              ),
            ),
          ],
        ),
      ),
      // Drawer
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Drawer App bar
            AppBar(
              title: Text(_email!),
              automaticallyImplyLeading: false,
            ),
            // Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).translate('mainScreenSettings')),
              onTap: () { 
                Navigator.popAndPushNamed(context, SettingsScreen.routeName);
              },
            ),
            const Divider(thickness: 1,),
            // Delete user
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(AppLocalizations.of(context).translate('mainScreenDelete')),
              onTap: () async {
                final returnValue = await showDialog(
                  barrierDismissible: false,
                  context: context, 
                  builder: modalDialogWindowBuilder(
                    title: AppLocalizations.of(context).translate('mainScreenDeleteTitle'),
                    message: AppLocalizations.of(context).translate('mainScreenDeleteContent'),
                    button0: AppLocalizations.of(context).translate('mainScreenDeleteYes'),
                    button1: AppLocalizations.of(context).translate('mainScreenDeleteNo'),
                  ),
                );
                // Handle Modal Dialog return value
                if(returnValue == 0){

                  // Close drawer
                  Navigator.of(context).pop();
                  
                  // Navigate to auth screen
                  Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);

                  // Delete account
                  // Delete picnote
                  Provider.of<AuthProvider>(context, listen: false).deleteUser(_uId!);
                  
                  // Show snackbar after delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate('mainScreenDeleteSnack')),
                    ),
                  );

                }else{
                  
                  // Close drawer
                  Navigator.of(context).pop();                  
                
                }
              },
            ),
            const Divider(thickness: 2,),
            // Logout            
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(AppLocalizations.of(context).translate('mainScreenLogout')),
              onTap: () { 
                Navigator.of(context).pop;
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: pic2NoteColRef.orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if (streamSnapshot.hasData) {
            // Read stream of notes
            _usrPic2Note = streamSnapshot.data!.docs.where((element){ return element.get('userId').toString().contains(_uId!);}).toList();
            return Container(
              // Conatiner height = device screen height - app bar height
              height: MediaQuery.of(context).size.height - 60,
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                child: ListView.builder(
                  itemCount: _usrPic2Note.length,
                  itemBuilder: (context, index){
                    final DocumentSnapshot _pic2NoteDoc = _usrPic2Note[index]; 
                    return Card(
                      // Set note background color according to Theme mode
                      color: Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight,
                      elevation: 5,
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).pushNamed(NoteScreenView.routeName,
                            arguments: {
                              'userId': _uId,
                              'title': _pic2NoteDoc['title'],
                              'note': _pic2NoteDoc['note'],
                              'pic': _pic2NoteDoc['pic'],
                              'date': _pic2NoteDoc['date'],
                            }
                          );
                        },
                        leading: CachedNetworkImage(
                          imageUrl: _pic2NoteDoc['pic'],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          placeholder: (context, url) => const SizedBox(
                            width: 10,
                            height: 10,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dateFormat.format(_pic2NoteDoc['date'].toDate()), style: const TextStyle(fontSize: 8, fontStyle: FontStyle.italic),),
                            Text(_pic2NoteDoc['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold,)),
                            Text(_pic2NoteDoc['note'], maxLines: 1, overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.pushNamed(context, NoteScreen.routeName,
                                    arguments: {
                                      'document': _pic2NoteDoc,
                                      'userId': _uId,
                                    }
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () async {
                                  final returnValue = await showDialog(
                                    barrierDismissible: false,
                                    context: context, 
                                    builder: modalDialogWindowBuilder(
                                      title: AppLocalizations.of(context).translate('mainScreenDeleteNoteTitle'),
                                      message: AppLocalizations.of(context).translate('mainScreenDeleteNoteContent'),
                                      button0: AppLocalizations.of(context).translate('mainScreenDeleteYes'),
                                      button1: AppLocalizations.of(context).translate('mainScreenDeleteNo'),
                                    ),
                                  );
                                  // Handle Modal Dialog return value
                                  if(returnValue == 0){
                                    // Delete picnote
                                    Provider.of<PicNoteProvider>(context, listen: false).deletePicNote(_pic2NoteDoc['noteId'],  _uId!);
      
                                    // Show snackbar after delete
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context).translate('mainScreenDeleteNoteSnack')),
                                      ),
                                    );
                                  }  
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            );  
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },  
      ),
    );
  }
}
