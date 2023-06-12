import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';

import '../services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late AuthService _myAuthService;
  late NotesService _myNoteService;
  late Future<DataBaseUser> _myDbUser;
  @override
  void initState() {
    _myAuthService = AuthService.firebase();
    _myNoteService = NotesService(); //Singletone

    _myDbUser = _myNoteService.getOrCreateUser(
        email: _myAuthService.currentUser!.userEmail!);

    super.initState();
  }

  @override
  void dispose() {
    //When the widget is taken out from the widget tree, then it will relase memory
    _myNoteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Main UI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
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
                    await _myAuthService.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      myRoutes.loginView,
                      (route) => false,
                    );
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
      body: FutureBuilder(
        future: _myDbUser,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _myNoteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Waiting for notes');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
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
