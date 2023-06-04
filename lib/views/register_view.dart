import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sing-up',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _password2,
                    decoration:
                        const InputDecoration(hintText: 'Confirm password'),
                    obscureText: true,
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      final password2 = _password2.text;
                      if (password == password2) {
                        try {
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user != null) {
                              if (user.emailVerified) {
                                Navigator.pushNamed(context, '/notesView');
                              } else {
                                Navigator.pushNamed(context, '/verifyEmail');
                              }
                            }
                          });
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            log('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            log('The account already exists for that email.');
                          } else if (e.code == 'invalid-email') {
                            log("Please, enter a valid email address");
                          } else {
                            log(e.code);
                          }
                        }
                      } else {
                        log("passwords does not coincide");
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false)
                          },
                      child: const Text('Go back to log-in')),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }

          /**
           
           */
        },
      ),
    );
  }
}
