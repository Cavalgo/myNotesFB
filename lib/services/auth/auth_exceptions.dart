abstract class MyExceptions {
  String get reason;
  String get description;
}

//Sign-in exceptions
class InvalidEmailException extends MyExceptions implements Exception {
  @override
  final String reason = 'Invalid email';
  @override
  final String description = 'The email address is not valid.';
}

class UserNotFoundException extends MyExceptions implements Exception {
  @override
  final String reason = 'User not found';
  @override
  final String description =
      'There is no user corresponding to the given email.';
}

class WrongPasswordException implements Exception, MyExceptions {
  @override
  final String reason = 'Wrong password';
  @override
  final String description = 'Password is invalid for the given email.';
}

class UserDisabledException implements Exception, MyExceptions {
  @override
  final String reason = 'User disabled';
  @override
  final String description =
      'User corresponding to the sgiven email has been disabled.';
}

//CreateUserWithEmailAndPassword:
//https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html

class EmailAlreadyInUseException implements Exception, MyExceptions {
  @override
  final String reason = 'Email already in use';
  @override
  final String description =
      'Already exists an account with the given email address.';
}

class WeakPasswordException implements Exception, MyExceptions {
  @override
  final String reason = 'Weak password';
  @override
  final String description = 'Please, use at least 6 digits';
}

class NotMatchingPasswordsException implements Exception, MyExceptions {
  @override
  final String reason = 'The passwords doesn\'t match';
  @override
  final String description = 'Please, make sure you write the same passwords';
}

// generic exceptions
class GenericAuthException implements Exception, MyExceptions {
  @override
  final String reason = 'There has been an issue';
  @override
  final String description = 'Please, check your credentials';
}

class UserNotLoggedInAuthException implements Exception, MyExceptions {
  @override
  final String reason = 'Not logged-in';
  @override
  final String description = 'Please, log-in';
}
