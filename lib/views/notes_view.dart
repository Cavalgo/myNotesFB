import 'package:flutter/material.dart';
import 'package:mynotes/auth_manager/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late AuthService myAuthService;
  @override
  void initState() {
    myAuthService = AuthService.firebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: const Text(
          'Main UI',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton<MenueActions>(
            padding: const EdgeInsets.only(right: 25.0),
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 35,
            ),
            onSelected: (value) async {
              switch (value) {
                case MenueActions.logout:
                  final userDecision = await showLogOutDialog(context);
                  devtools.log(userDecision.toString());
                  if (userDecision) {
                    await myAuthService.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, myRoutes.loginView, (route) => false);
                  }
                  break;
                case MenueActions.two:
                  devtools.log('two');
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<MenueActions>>[
              const PopupMenuItem<MenueActions>(
                value: MenueActions.logout,
                child: Text('Log out'),
              ),
              const PopupMenuItem<MenueActions>(
                value: MenueActions.two,
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
  ).then((value) =>
      value ?? false); //Sii no es null lo retorna, si es null, retorna falso
}
