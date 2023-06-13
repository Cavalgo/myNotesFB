import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class AddNewNoteView extends StatefulWidget {
  const AddNewNoteView({super.key});

  @override
  State<AddNewNoteView> createState() => _AddNewNoteViewState();
}

class _AddNewNoteViewState extends State<AddNewNoteView> {
  DataBaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DataBaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUserEmail = AuthService.firebase().currentUser!.userEmail;
    DataBaseUser owener = await _notesService.getUser(email: currentUserEmail!);
    final note = await _notesService.createNote(owner: owener);
    _note = note;
    return note;
  }

  void _deleteNoteIfEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _notesService = NotesService();
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
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener((_textControllerListener));
    _textController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final note = snapshot.data as DataBaseNote;
            _note = note;
            _setUpTextControllerListener();
            return TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null, //Not limit of lines
              decoration:
                  const InputDecoration(hintText: 'Write your note here...'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
