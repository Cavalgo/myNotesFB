import 'package:flutter/material.dart';

final myAlert = _MyShowDialog();

class _MyShowDialog {
  Future<void> showErrorDialog(
    BuildContext context,
    String exception,
    String description,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            exception,
            textAlign: TextAlign.center,
          ),
          content: Text(
            description,
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
