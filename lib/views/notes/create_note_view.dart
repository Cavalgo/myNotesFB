import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/firebase_provider.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateUpdateNoteView();
}

class _CreateUpdateNoteView extends State<CreateNoteView> {
  late final FirestoreProvider _myFirestoreProvider;
  late final AuthService _myAuthService;
  late final TextEditingController _noteController;
  String? initialText;

  void _saveNoteIfTextNotEmpty() async {
    final text = _noteController.text;
    if (text.isNotEmpty) {
      await _myFirestoreProvider.createNewNoteWithText(
          ownerUserId: _myAuthService.currentUser!.userId, text: text);
    }
  }

  @override
  void initState() {
    _myAuthService = AuthService.firebase();
    _noteController = TextEditingController();
    _myFirestoreProvider = FirestoreProvider.instance;

    super.initState();
  }

  @override
  void dispose() {
    _saveNoteIfTextNotEmpty();
    _noteController.dispose();

    super.dispose();
  }

//_setUpTextControllerListener();
  @override
  Widget build(BuildContext context) {
    //Here we are getting the arguments we passed from List view
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_noteController.text.isEmpty) {
                cannotShareEmptyNoteDialog(context);
              } else {
                Share.share(_noteController.text);
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: TextField(
        controller: _noteController,
        keyboardType: TextInputType.multiline,
        maxLines: null, //Not limit of lines
        decoration: const InputDecoration(hintText: 'Write your note here...'),
      ),
    );
  }
}
