import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

//Immutable makes the instance of a class immutable
//Meaning that once it's declare you cannot modify it
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser? user;
  const AuthStateLoggedIn({required this.user});
}

class AuthStateNeedsVerification extends AuthState {
  final String email;
  const AuthStateNeedsVerification({required this.email});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool loading;
  const AuthStateLoggedOut({required this.exception, required this.loading});

  @override
  List<Object?> get props => [exception, loading];
}

class AuthStateInRegisterView extends AuthState {
  final Exception? exception;
  final bool loading;
  const AuthStateInRegisterView(
      {required this.exception, required this.loading});
}
