import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/firestore_constants.dart';
import 'package:mynotes/services/cloud/firestore_exceptions.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';

class FirebaseProvider {
  final notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  //singletone
  FirebaseProvider._fbPrivateConstructor();

  static final FirebaseProvider instance =
      FirebaseProvider._fbPrivateConstructor();
  //Singletone

  //Strea
  Stream<List<FirestoreNote>> allNotes({
    required String ownerUserID,
  }) {
    final userNotes = notes.where(ownerUserID, isEqualTo: ownerUserID);

    return userNotes.snapshots().map((event) =>
        event.docs.map((e) => FirestoreNote.fromSnapshot(e)).toList());
  }
  // =>
  //notes.snapshots().map((event) =>
  //  event.docs.map((e) => FirestoreNote.fromSnapshot(e)).toList());

  Future<List<FirestoreNote>> getNotes({
    required String ownerUserId,
  }) async {
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

  Future<void> createNewNote({
    required String ownerUserID,
  }) async {
    await notes.add({
      ownerUserID: ownerUserID,
      textFieldName: '',
    });
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (_) {
      throw FirestoreCouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes
          .doc(
            documentId,
          )
          .delete();
    } catch (_) {
      throw FirestoreCouldNotDeleteNoteException();
    }
  }
}
