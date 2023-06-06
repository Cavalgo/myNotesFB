import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/my_alert_dialog.dart';

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
              backgroundColor: Colors.amber,
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
                        final String emailUser = _email.text;
                        final String passwordUser = _password.text;
                        //We use e.runType to know what is the exception class(type)
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailUser, password: passwordUser);
                          final user = userCredential.user;
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
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            log('No user found for that email.');
                            myAlert.showErrorDialog(context, 'Email not found',
                                'If you have not signed out yet, please click register');
                          } else if (e.code == 'wrong-password') {
                            myAlert.showErrorDialog(
                                context,
                                'Wrong password',
                                'The password entered is invalid. If you '
                                    'forgot your password, click on:\n Forget password?');
                          } else if (e.code == 'invalid-email') {
                            myAlert.showErrorDialog(context, 'Invalid email',
                                'Please, enter a valid email');
                          } else {
                            myAlert.showErrorDialog(
                              context,
                              'Issue with the credentials',
                              e.code,
                            );
                          }
                          //here, we catch any other type of exception
                        } catch (e) {
                          myAlert.showErrorDialog(
                            context,
                            'There is an issue',
                            e.toString(),
                          );
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
