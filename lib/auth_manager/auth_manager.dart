import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';

abstract class AuthManager {
  late FirebaseApp _fireBaseApp;

// We instanziate our firebase
  Future<FirebaseApp>? startFirebase() async {
    _fireBaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    return _fireBaseApp;
  }

  User? getUserWithCredential(credential) {
    return credential.user;
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }
}
