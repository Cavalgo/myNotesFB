import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';

import '../../services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late AuthService _myAuthService;
  late NotesService _myNoteService;
  late Future<DataBaseUser> _myDbUser;
  //** INITSTATE **/
  @override
  void initState() {
    _myAuthService = AuthService.firebase();
    _myNoteService = NotesService(); //Singletone

    //Creating a Future variable
    _myDbUser = _myNoteService.getOrCreateUser(
        email: _myAuthService.currentUser!.userEmail!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  myRoutes.addNewNoteView,
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 33,
              )),
          PopupMenuButton<MenueActions>(
            padding: const EdgeInsets.only(right: 20.0),
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
                stream: _myNoteService.allNotesStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    //return const CircularProgressIndicator();
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DataBaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, int index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                _myNoteService.deleteNote(id: note.id);
                              },
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
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