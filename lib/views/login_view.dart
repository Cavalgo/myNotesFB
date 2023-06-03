import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                        const InputDecoration(hintText: 'Enter password'),
                  ),
                  TextButton(
                      onPressed: () async {
                        final String emailUser = _email.text;
                        final String passwordUser = _password.text;
                        //We use e.runType to know what is the exception class(type)
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailUser, password: passwordUser);
                          print(credential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          } else {
                            print(e.code);
                          }
                        }
                      },
                      child: const Text('Log-in')),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Not registered yet? Click here!'),
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
