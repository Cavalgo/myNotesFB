import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/cloud/firebase_provider.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';
import 'package:mynotes/utilities/dialogs/log_out_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late AuthService _myAuthService;
  late FirestoreProvider _myFirestoreProvider;

  @override
  void initState() {
    _myAuthService = AuthService.firebase();
    _myFirestoreProvider = FirestoreProvider.instance; //Singletone

    //Creating a Future variable
    // _myDbUser = _myFirestoreProvider.getOrCreateUser(
    //    userEmail: _myAuthService.currentUser!.userEmail);

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
                  MyRoutes.createNoteView,
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
                  if (userDecision) {
                    BlocProvider.of<AuthBloc>(context)
                        .add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<MenueActions>>[
              const PopupMenuItem<MenueActions>(
                value: MenueActions.logout,
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _myFirestoreProvider.allNotes(
            ownerUserID: _myAuthService.currentUser!.userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              devtools.log('Connection is active');
              if (snapshot.hasData) {
                final allNotes = snapshot.data as List<FirestoreNote>;
                allNotes.sort(
                    (a, b) => b.lastDateModified.compareTo(a.lastDateModified));
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (FirestoreNote note) {
                    _myFirestoreProvider.deleteNote(
                        documentId: note.documentId);
                  },
                  onTapNote: (FirestoreNote note) async {
                    await Navigator.pushNamed(context, MyRoutes.updateNoteView,
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
      ),
    );
  }
}
