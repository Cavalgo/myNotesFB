import 'package:flutter/material.dart';

//The first T indicates it can work with different values
//typedef DialogOptionBuilder<T> = Map<String, T?>;

Future<T?> showGenericDialog<T>(
    {required BuildContext context,
    required String title,
    required String content,
    required Map<String, T?> options}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T? value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}

/*
.then((value) =>
      value ?? false); //Sii no es null lo retorna, si es null, retorna falso
}
*/