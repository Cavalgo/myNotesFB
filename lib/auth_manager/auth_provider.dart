/*
Auth provider getter, gets the current user

*/
import 'package:mynotes/auth_manager/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialize();

  //We create the definition of the log-in, and set  some attirbutes as mandatory
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password1,
    required String password2,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
}
