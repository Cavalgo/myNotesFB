import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_constants.dart';

class FirestoreNote {
  final String documentId;
  final String ownerUserId;
  final Timestamp lastDateModified;
  final String text;

  const FirestoreNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.lastDateModified,
  });

  FirestoreNote.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        lastDateModified = snapshot.data()[lastModifiedDateFieldName],
        text = snapshot.data()[textFieldName];
}
