import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/logged_user_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LogInView(),
      '/register': (context) => const RegisterView(),
      '/verifyEmail': (context) => const VerifyEmailView(),
      '/loggedin': (context) => const LoggedUserView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      //We create a future builder to initilize the FireBase
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            //refreshes the current user if signed in
            currentUser.reload();
            if (currentUser.emailVerified) {
              return const LogInView(); //LoggedUserView();
            } else {
              return const LogInView(); //VerifyEmailView();
            }
          } else {
            return const LogInView();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Error loading firebase');
        }
      },
    );
  }
}
