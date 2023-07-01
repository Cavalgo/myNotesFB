import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/firestore_constants.dart';
import 'package:mynotes/services/cloud/firestore_exceptions.dart';
import 'package:mynotes/services/cloud/firestore_note.dart';

class FirestoreProvider {
  final notes = FirebaseFirestore.instance.collection('notes');

  //singletone
  FirestoreProvider._fbPrivateConstructor();

  static final FirestoreProvider instance =
      FirestoreProvider._fbPrivateConstructor();
  //Singletone

  //Stream
  Stream<List<FirestoreNote>> allNotes({
    required String ownerUserID,
  }) {
    final userNotes = notes.where(ownerUserIdFieldName, isEqualTo: ownerUserID);
    final tobR = userNotes.snapshots().map((event) =>
        event.docs.map((doc) => FirestoreNote.fromSnapshot(doc)).toList());
    return tobR;
  }
  // =>
  //notes.snapshots().map((event) =>
  //  event.docs.map((e) => FirestoreNote.fromSnapshot(e)).toList());

  Future<List<FirestoreNote>> getNotes({required String ownerUserId}) async {
    try {
      final notesQuery =
          await notes.where(ownerUserId, isEqualTo: ownerUserId).get();

      final notesQueryList = notesQuery.docs;
      final firestoreNotesIterable =
          notesQueryList.map((e) => FirestoreNote.fromSnapshot(e));
      final firestoreNotesList = firestoreNotesIterable.toList();
      return firestoreNotesList;
    } catch (e) {
      throw FirestoreCouldNotGetAllNotesException();
    }
  }

  Future<FirestoreNote> createNewNote({required String ownerUserId}) async {
    try {
      DocumentReference<Map<String, dynamic>> newNoteReference =
          await notes.add({
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
        lastModifiedDateFieldName: DateTime.now(),
      });

      DocumentSnapshot<Map<String, dynamic>> newNoteDocument =
          await newNoteReference.get();

      return FirestoreNote(
          documentId: newNoteDocument.id,
          ownerUserId: ownerUserId,
          text: '',
          lastDateModified: Timestamp.now());
    } catch (e) {
      throw Exception(e.toString());
    }
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

  Future<void> updateNoteDate({required String documentId}) async {
    try {
      await notes.doc(documentId).update({
        lastModifiedDateFieldName: DateTime.now(),
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
