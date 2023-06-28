import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//import 'package:firebase_auth/firebase_auth.dart';
@immutable
class AuthUser {
  final bool isEmailVerfied;
  final String userEmail;
  final String userId;

  //Constructor privaddo
  const AuthUser({
    required this.isEmailVerfied,
    required this.userEmail,
    required this.userId,
  });

  //Esto es lo que llamamos y recibe un usuario
  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      isEmailVerfied: user.emailVerified,
      userEmail: user.email!,
      userId: user.uid,
    );
  }
}
