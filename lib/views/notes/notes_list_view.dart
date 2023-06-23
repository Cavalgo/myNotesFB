import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/delete_note_dialog.dart';

//When we want to pass a function as an argument
typedef NoteCallback = void Function(DataBaseNote note);

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;

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
        DataBaseNote note = notes[index];
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
