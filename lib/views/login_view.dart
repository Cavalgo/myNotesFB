import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' show log;
import 'package:mynotes/constants/routes.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.currentUser?.reload();
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Log-in',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                backgroundColor: Colors.blue,
              ),
              body: ListView(
                children: [
                  TextField(
                    controller: _email,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email'),
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter your password'),
                  ),
                  TextButton(
                      onPressed: () async {
                        FirebaseAuth.instance
                            //Listener for user status
                            .authStateChanges()
                            .listen((User? user) async {
                          if (user != null) {
                            if (user.emailVerified) {
                              await Navigator.pushNamedAndRemoveUntil(
                                context,
                                myRoutes.notesView,
                                (route) => false,
                              );
                            } else {
                              await Navigator.pushNamedAndRemoveUntil(
                                context,
                                myRoutes.verifyEmail,
                                (route) => false,
                              );
                            }
                          }
                        });
                        final String emailUser = _email.text;
                        final String passwordUser = _password.text;
                        //We use e.runType to know what is the exception class(type)
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailUser, password: passwordUser);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            log('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            log('Wrong password provided for that user.');
                          } else {
                            log(e.code);
                          }
                        }
                      },
                      child: const Text('Log-in')),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        myRoutes.registerView,
                      );
                    },
                    child: const Text('Not registered yet? Register here!'),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return const Text('error');
          }
        });
  }
}
