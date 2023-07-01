import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(
  BuildContext context,
) async {
  showGenericDialog(
    context: context,
    title: "Empty Note",
    content: "You cannot share empty note!",
    options: {'Ok': null},
  );
}
