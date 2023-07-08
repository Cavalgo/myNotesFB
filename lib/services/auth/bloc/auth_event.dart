import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/bloc/auth_state.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn({
    required this.email,
    required this.password,
  });
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String password2;
  const AuthEventRegister({
    required this.email,
    required this.password,
    required this.password2,
  });
}

class AuthEventCheckEmailVerified extends AuthEvent {}
