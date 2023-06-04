import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';

enum MyDropDownItems { logout, two }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main UI',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton<MyDropDownItems>(
            padding: const EdgeInsets.only(right: 25.0),
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 35,
            ),
            onSelected: (value) async {
              FirebaseAuth.instance
                  .authStateChanges()
                  .listen((User? user) async {
                if (user == null) {
                  await Navigator.pushNamedAndRemoveUntil(
                      context, myRoutes.loginView, (route) => false);
                }
              });
              switch (value) {
                case MyDropDownItems.logout:
                  final userDecision = await showLogOutDialog(context);
                  devtools.log(userDecision.toString());
                  if (userDecision) {
                    await FirebaseAuth.instance.signOut();
                  }
                  break;
                case MyDropDownItems.two:
                  devtools.log('two');
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<MyDropDownItems>>[
              const PopupMenuItem<MyDropDownItems>(
                value: MyDropDownItems.logout,
                child: Text('Log out'),
              ),
              const PopupMenuItem<MyDropDownItems>(
                value: MyDropDownItems.two,
                child: Text('Item 2'),
              ),
            ],
          ),
        ],
      ),
      body: const Text('Welcome to your notes!'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want yo sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
