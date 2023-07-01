/*
class DatabaseAlreadyOpenedException implements Exception {
  final String message;
  DatabaseAlreadyOpenedException(this.message);
  @override
  String toString() {
    return message;
  }
}

class DatabaseIsNotOpenedException implements Exception {
  final String message;
  DatabaseIsNotOpenedException(this.message);
  @override
  String toString() {
    return message;
  }
}

class UnableToDeleteUserException implements Exception {
  final String message;
  UnableToDeleteUserException(this.message);
  @override
  String toString() {
    return message;
  }
}

class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);
  @override
  String toString() {
    return message;
  }
}

class UnableToInsertUserException implements Exception {
  String? message;
  UnableToInsertUserException({this.message});
  @override
  String toString() {
    String? myMessage = message;
    if (myMessage == null) {
      return 'Was not possible to insert';
    }
    return myMessage;
  }
}

class UnableToDeleteNoteException implements Exception {}

class UnableToInsertNoteException implements Exception {}

class NoteDoesNotExistException implements Exception {}

class CouldNotUpdateNoteException implements Exception {}
*/
