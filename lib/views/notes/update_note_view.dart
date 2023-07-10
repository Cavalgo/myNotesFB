import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/cloud/firebase_provider.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'get_argument.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({super.key});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
  late final TextEditingController _noteController;
  late final FirestoreNote _myNote;
  late final String _myInitialNoteText;
  late final FirestoreProvider _myFirebaseProvider;

  @override
  void initState() {
    _noteController = TextEditingController();
    _myFirebaseProvider = FirestoreProvider.instance;
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    if (_myInitialNoteText != _noteController.text) {
      _myFirebaseProvider.updateNote(
        documentId: _myNote.documentId,
        text: _noteController.text,
      );
      _myFirebaseProvider.updateNoteDate(documentId: _myNote.documentId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreNote? myArgs = context.getArgument<FirestoreNote>();
    if (myArgs != null) {
      _myNote = myArgs;
      _myInitialNoteText = _myNote.text;
      _noteController.text = _myInitialNoteText;
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, MyRoutes.createNoteView, (route) => false);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Update Note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () async {
                String text = _noteController.text;
                if (text.isEmpty) {
                  await cannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: TextField(
        decoration: const InputDecoration(hintText: 'Write your note here'),
        controller: _noteController,
      ),
    );
  }
}
