import 'package:flutter/material.dart';
/*
class CreateUpdateArguments<T> {
  final T argument;
  CreateUpdateArguments(
    this.argument,
  );
}
*/

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    T? myArgs = ModalRoute.of(this)!.settings.arguments as T;
    return myArgs;
  }
}
