import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/my_alert_dialog.dart';
import 'package:mynotes/auth_manager/auth_service.dart';
import 'package:mynotes/auth_manager/auth_exceptions.dart';

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
    //We intilize the
    AuthService myAuthService = AuthService.firebase();
    return FutureBuilder(
        future: myAuthService.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            () async {
              await myAuthService.reloadUser();
            };
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
                        final String userEmail = _email.text;
                        final String userPassword = _password.text;
                        try {
                          final currentUser = await myAuthService.logIn(
                              email: userEmail, password: userPassword);
                          if (currentUser.isEmailVerfied) {
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
                        } catch (e) {
                          if (e is MyExceptions) {
                            myAlert.showErrorDialog(
                                context, e.reason, e.description);
                          } else {
                            myAlert.showErrorDialog(
                                context,
                                GenericAuthException().reason,
                                GenericAuthException().description);
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
