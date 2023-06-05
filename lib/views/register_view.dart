import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/my_alert_dialog.dart';

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
        backgroundColor: Colors.blue,
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
                      hintText: 'Enter email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    decoration:
                        const InputDecoration(hintText: 'Enter password'),
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
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          //firebase listener on
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user != null) {
                              if (user.emailVerified) {
                                Navigator.pushNamed(
                                    context, myRoutes.notesView);
                              } else {
                                Navigator.pushNamed(
                                    context, myRoutes.verifyEmail);
                              }
                            }
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            myAlert.showErrorDialog(
                              context,
                              'Weak password',
                              'Password should be at least 6 characters',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            myAlert.showErrorDialog(
                              context,
                              'Email already in use',
                              'The email address is already in use by another account',
                            );
                          } else if (e.code == 'invalid-email') {
                            myAlert.showErrorDialog(
                              context,
                              'Invalid email',
                              'The email address is badly formatted',
                            );
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
                                context, myRoutes.loginView, (route) => false)
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
