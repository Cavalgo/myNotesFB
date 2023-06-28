class CloudFirestoreException implements Exception {}

//Create
class FirestoreCouldNotCreateNoteException extends CloudFirestoreException {}

//Read
class FirestoreCouldNotGetAllNotesException extends CloudFirestoreException {}

//Update
class FirestoreCouldNotUpdateNoteException extends CloudFirestoreException {}

//Delete
class FirestoreCouldNotDeleteNoteException extends CloudFirestoreException {}
