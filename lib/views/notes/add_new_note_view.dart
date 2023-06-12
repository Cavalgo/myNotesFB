import 'package:flutter/material.dart';

class AddNewNoteView extends StatefulWidget {
  const AddNewNoteView({super.key});

  @override
  State<AddNewNoteView> createState() => _AddNewNoteViewState();
}

class _AddNewNoteViewState extends State<AddNewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: const Text('Add your new note here'),
    );
  }
}
