import 'package:flutter/material.dart';

WidgetBuilder modalDialogWindowBuilder({required String title, required String message, required String button0, required String button1, dynamic returnValue}) {
  return (BuildContext context) => AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[
      TextButton(
        onPressed: (){
          Navigator.of(context).pop(0);
        }, 
        child: Text(button0),
      ),
      TextButton(
        onPressed: (){
          Navigator.of(context).pop(1);
        }, 
        child: Text(button1)
      ),
    ]
  );
}