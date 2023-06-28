import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/utilities/dialogs/log_out_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

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
        userEmail: _myAuthService.currentUser!.userEmail);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                  MyRoutes.createUpdateNoteView,
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
                  final userDecision = await logOutDialog(
                    context: context,
                  );
                  devtools.log(userDecision.toString());
                  if (userDecision) {
                    await _myAuthService.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MyRoutes.loginView,
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
        //We get or create user and also we initilize our steam and get our notes
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
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        devtools.log(snapshot.hasData.toString());
                        final allNotes = snapshot.data as List<DataBaseNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (DataBaseNote note) {
                            _myNoteService.deleteNote(id: note.id);
                          },
                          onTapNote: (note) async {
                            await Navigator.pushNamed(
                                context, MyRoutes.updateNoteView,
                                arguments: note);
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
