import 'package:flutter/material.dart';

WidgetBuilder modalMessageWindowBuilder({required String title, required String message, required String button0}) {
  return (BuildContext context) => AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[
      TextButton(
        onPressed: (){
          Navigator.of(context).pop();
        }, 
        child: Text(button0),
      ),
    ]
  );
}