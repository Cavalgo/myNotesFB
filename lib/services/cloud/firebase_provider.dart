import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/firestore_constants.dart';
import 'package:mynotes/services/cloud/firestore_exceptions.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';

class FirebaseProvider {
  final notes = FirebaseFirestore.instance.collection('notes');
  //singletone
  FirebaseProvider._fbPrivateConstructor();

  static final FirebaseProvider instance =
      FirebaseProvider._fbPrivateConstructor();
  //Singletone

  Future<List<FirestoreNote>> getNotes({required String ownerUserId}) async {
    try {
      final notesQuery = await notes
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get();

      final notesQueryList = notesQuery.docs;
      final firestoreNotesIterable =
          notesQueryList.map((e) => FirestoreNote.fromSnapshot(e));
      final firestoreNotesList = firestoreNotesIterable.toList();
      return firestoreNotesList;
    } catch (e) {
      throw FirestoreCouldNotGetAllNotesException();
    }
  }

  Future<void> createNewNote({required String ownerUserID}) async {
    await notes.add({
      ownerUserID: ownerUserID,
      textFieldName: '',
    });
  }
}
