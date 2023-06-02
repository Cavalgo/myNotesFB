import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
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
          FirebaseAuth.instance
              .authStateChanges() //Let's check the current user state
              .listen((User? user) {
            if (user != null) {
              if (user.emailVerified) {
                print('You are a verified user');
              } else {
                print('Please, verify your email');
              }
            }
            /*
            if (user?.emailVerified ?? false) {
              print("You're a verified user");
            } else {
              print("You need to verify your email first");
            }*/
          });
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Home Page',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.lightGreen,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('error');
        }
      },
    );
  }
}
