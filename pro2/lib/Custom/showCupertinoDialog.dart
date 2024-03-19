import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMyDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required VoidCallback onPressed,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoTheme(
      data: const CupertinoThemeData(
        primaryColor: Colors.blue,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(actionText),
            onPressed: () {
              onPressed();
              Navigator.of(context).pop();
            },
          ),
          // cancel button
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}
