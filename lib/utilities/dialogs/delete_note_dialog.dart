import 'generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> deleteNoteDialog({
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    options: {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => (value == true) ? true : false);
}
