import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'get_argument.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({super.key});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
  final TextEditingController _noteController = TextEditingController();
  late final DataBaseNote _myNote;
  late final String _myInitialNoteText;
  final _myDatabaseService = NotesService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    if (_myInitialNoteText != _noteController.text) {
      _myDatabaseService.updateNote(note: _myNote, text: _noteController.text);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DataBaseNote? myArgs = context.getArgument<DataBaseNote>();
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
