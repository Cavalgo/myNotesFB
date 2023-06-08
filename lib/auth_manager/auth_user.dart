import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//import 'package:firebase_auth/firebase_auth.dart';
@immutable
class AuthUser {
  final bool isEmailVerfied;
  final String userEmail;

  //Constructor privaddo
  const AuthUser._(this.isEmailVerfied, this.userEmail);

  //Esto es lo que llamamos y recibe un usuario
  factory AuthUser.fromFirebase(User user) {
    final String userEmail = user.email ?? '';
    return AuthUser._(user.emailVerified, userEmail);
  }
}
