import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    //This prevents the user to dimiss the dialog
    barrierDismissible: false,
    builder: (context) {
      return dialog;
    },
  );

  return () => Navigator.of(context).pop();
}
