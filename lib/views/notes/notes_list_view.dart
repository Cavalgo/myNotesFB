import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';
import 'package:mynotes/utilities/dialogs/delete_note_dialog.dart';

//When we want to pass a function as an argument
typedef NoteCallback = void Function(FirestoreNote note);

class NotesListView extends StatelessWidget {
  final List<FirestoreNote> notes;

  //Out typedef indicates it must receive a DataBaseNote
  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, int index) {
        FirestoreNote note = notes[index];
        return ListTile(
          onTap: () => onTapNote(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await deleteNoteDialog(context: context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
