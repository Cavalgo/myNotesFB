import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/cloud/firebase_provider.dart';
import 'package:mynotes/services/cloud/firestore_constants.dart';
import 'package:mynotes/services/crud/notes_service.dart';
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
          context, MyRoutes.createUpdateNoteView, (route) => false);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Note'),
      ),
      body: TextField(
        decoration: const InputDecoration(hintText: 'Write your note here'),
        controller: _noteController,
      ),
    );
  }
}
