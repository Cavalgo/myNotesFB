import 'generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> logOutDialog({
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: 'Log-out',
    content: 'Are you sure you want to log-out?',
    options: {
      'log-out': true,
      'Cancel': false,
    },
  ).then((value) => (value == true) ? true : false);
}
