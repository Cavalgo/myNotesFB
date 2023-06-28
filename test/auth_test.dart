import 'dart:developer';

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

class NotInitializedException implements Exception {
  String reason = 'The server provider has not yet been initialized';
}

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    //1: At first provider should't be initialized
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    //2: Test logging out before initialazig
    test('Cannt log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    //3: Initialize server
    test('Server should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    //4: User should not be initilized
    test('User should be null after inizialization', () {
      expect(provider.currentUser, null);
    });
    //5: Testing initialization time
    test('Initilization should occur within two or less seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 5)));
    //6: Creating a user
    test('Creating a user', () async {
      //6.1: UserNotFoundException
      final testUserWrongEmail = provider.createUser(
        email: 'foo@bar.baz', //foo@bar.baz
        password1: 'pepe123',
        password2: 'pepe123',
      );
      expect(testUserWrongEmail,
          throwsA(const TypeMatcher<UserNotFoundException>()));

      //6.2: WrongPasswordException
      final testUserWronPassword = provider.createUser(
        email: 'carlos@gmail.com',
        password1: 'fobarbaz',
        password2: 'fobarbaz',
      );
      expect(testUserWronPassword,
          throwsA(const TypeMatcher<WrongPasswordException>()));

      //6.3: InvalidEmailException
      final testUserBadlyFormattedEmail = provider.createUser(
        email: 'carlosgmail.com',
        password1: 'pepe123',
        password2: 'pepe123',
      );
      expect(testUserBadlyFormattedEmail,
          throwsA(const TypeMatcher<InvalidEmailException>()));

      //6.3: Creating a user with corret credentials
      final wellCreatedUser = await provider.createUser(
        email: 'user@gmail.com',
        password1: 'userpassword123',
        password2: 'userpassword123',
      );
      expect(provider.currentUser, wellCreatedUser);

      //6.4 User's email should be false
      expect(provider.currentUser?.isEmailVerfied, false);
    });

    test('New user verification process', () async {
      //7 Send email verification current user should be verified
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      //expect(user, isNotNull);
      expect(user!.isEmailVerfied, true);
    });

    test('User log out and log in again', () async {
      //8 user should be null
      await provider.logOut();
      var user = provider.currentUser;
      expect(user, null);
      //9 User should not be null
      final user2 = await provider.createUser(
        email: 'user@gmail.com',
        password1: 'userpassword123',
        password2: 'userpassword123',
      );
      expect(provider.currentUser, user2);
    });
  });
}

//We are going to replicate the funcitionality of our current AuthProvider and make sure it works as excpected.
//Here we have full control, and we are gonna do some tests such as: Never call a function before initliazing the
//Firebase app: 17:04:36
class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email,
      required String password1,
      required String password2}) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (password1 != password2) {
      throw NotMatchingPasswordsException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return await logIn(email: email, password: password1);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    log(isInitialized.toString());
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (isInitialized == false) {
      throw NotInitializedException();
    }
    if (email == 'foo@bar.baz') {
      throw UserNotFoundException();
    }
    if (password == 'fobarbaz') {
      throw WrongPasswordException();
    }
    if (!email.contains('@')) {
      throw InvalidEmailException();
    }
    _user =
        AuthUser(isEmailVerfied: false, userEmail: email, userId: 'idGeneric');
    return Future.value(_user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotFoundException();
    }
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> reloadUser() {
    throw UserNotFoundException();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundException();
    }

    _user = AuthUser(
        isEmailVerfied: true,
        userEmail: _user!.userEmail,
        userId: 'userIdGeneric');
  }
}
