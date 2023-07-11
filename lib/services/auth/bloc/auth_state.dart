import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

//Immutable makes the instance of a class immutable
//Meaning that once it's declare you cannot modify it
@immutable
abstract class AuthState {
  final bool loading;
  final String loadingText;
  const AuthState({
    required this.loading,
    this.loadingText = 'Please, wait a moment',
  });
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({
    required super.loading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser? user;
  const AuthStateLoggedIn({
    required this.user,
    required super.loading,
  });
}

class AuthStateNeedsVerification extends AuthState {
  final String email;
  const AuthStateNeedsVerification({
    required this.email,
    required super.loading,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.loading,
  });

  @override
  List<Object?> get props => [
        exception,
        loading,
      ];
}

class AuthStateInRegisterView extends AuthState {
  final Exception? exception;
  const AuthStateInRegisterView({
    required this.exception,
    required super.loading,
  });
}
