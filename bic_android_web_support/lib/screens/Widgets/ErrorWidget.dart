import 'package:flutter/material.dart';


void showErrorDialogWidget(BuildContext context,String message) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'))
        ],
      ));
}
