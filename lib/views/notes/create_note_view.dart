import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
//import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/services/cloud/firebase_provider.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateUpdateNoteView();
}

class _CreateUpdateNoteView extends State<CreateNoteView> {
  //DataBaseNote? _note;
  //late final Function createNoteAndGetUserFuture;
  //late final NotesService _notesService;
  FirestoreNote? _fbNote;
  late final FirestoreProvider _myFirebaseProvider;
  late final AuthService _myAuthService;
  late final TextEditingController _textController;
  String? initialText;

  Future<void> createNote() async {
    final id = _myAuthService.currentUser!.userId;
    final note = await _myFirebaseProvider.createNewNote(ownerUserId: id);
    _fbNote = note;
  }

  void _deleteNoteIfEmpty() async {
    final note = _fbNote;
    if (_textController.text.isEmpty && note != null) {
      await _myFirebaseProvider.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _fbNote;
    final text = _textController.text;
    //if (note != null && text.isNotEmpty && text != initialText)
    if (note != null && text.isNotEmpty) {
      await _myFirebaseProvider.updateNote(
          documentId: note.documentId, text: text);
    }
  }

  @override
  void initState() {
    _myAuthService = AuthService.firebase();
    _textController = TextEditingController();
    _myFirebaseProvider = FirestoreProvider.instance;

    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();

    super.dispose();
  }

  void _textControllerListener() async {
    final note = _fbNote;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _myFirebaseProvider.updateNote(
        documentId: note.documentId, text: text);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener((_textControllerListener));
    _textController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    //Here we are getting the arguments we passed from List view
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: createNote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _setUpTextControllerListener();
            return TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null, //Not limit of lines
              decoration:
                  const InputDecoration(hintText: 'Write your note here...'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
