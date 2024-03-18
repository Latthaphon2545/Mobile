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
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(actionText),
          onPressed: onPressed,
        ),
      // cacle button
        CupertinoDialogAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}