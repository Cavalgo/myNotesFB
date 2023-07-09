import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

//Immutable makes the instance of a class immutable
//Meaning that once it's declare you cannot modify it
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateRegisterFailure extends AuthState {
  final Exception exception;
  const AuthStateRegisterFailure(this.exception);
}
