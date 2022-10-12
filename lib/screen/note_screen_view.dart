//
// ./screen/note_screen_view.dart
//

// Flutter imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Local imports
import 'package:pic2note/helper/colors.dart';
import 'package:provider/provider.dart';
import 'package:pic2note/provider/theme_provider.dart';
import 'package:pic2note/app_localizations.dart';
import 'package:pic2note/widget/imagefullscreen_widget.dart';

class NoteScreenView extends StatefulWidget {
  const NoteScreenView({Key? key}) : super(key: key);

  static String routeName = 'note_screen_view';

  @override
  _NoteScreenViewState createState() => _NoteScreenViewState();
}

class _NoteScreenViewState extends State<NoteScreenView> {
  String _title = '';
  String _note = '';
  String _pic = '';
  DateTime _date = DateTime.now();

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void didChangeDependencies() {
    // Get routing argument(s)
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _title = arguments['title'];
    _note = arguments['note'];
    _pic = arguments['pic'];
    _date = arguments['date'].toDate();

    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('noteScreenViewTitle')),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('noteScreenViewDateLabel'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PhysicalModel(
                      color: (Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight)!,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dateFormat.format(_date),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),                    
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: _pic,
                          width: 200,
                          height: 200,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                            strokeWidth: 4.0,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        onTap: () {
                          // Show image full screen
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return ImageFullScreen(_pic);
                          }));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('noteScreenViewTitleLabel'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PhysicalModel(
                      color: (Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight)!,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(_title),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('noteScreenViewNoteLabel'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PhysicalModel(
                      color: (Provider.of<ThemeProvider>(context).isDarkModeOn ? AppColors.noteBackgroundDark : AppColors.noteBackgroundLight)!,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 120,
                        alignment: Alignment.topLeft,
                        child: Text(_note),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(203, 48),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context).translate('noteScreenViewButton'),
                style: const TextStyle(
                  fontSize: 14,
                ),
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
