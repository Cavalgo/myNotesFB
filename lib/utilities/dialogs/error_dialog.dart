import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text1,
  String text2,
) {
  return showGenericDialog<void>(
    context: context,
    title: text1,
    content: text2,
    options: {'Ok': null},
  );
}
