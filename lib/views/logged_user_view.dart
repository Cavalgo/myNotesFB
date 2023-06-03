import 'package:flutter/material.dart';

class LoggedUserView extends StatefulWidget {
  const LoggedUserView({super.key});

  @override
  State<LoggedUserView> createState() => _LoggedUserViewState();
}

class _LoggedUserViewState extends State<LoggedUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("You're logged in!"),
      ),
    );
  }
}
