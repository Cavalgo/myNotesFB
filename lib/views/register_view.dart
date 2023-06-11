import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
    //Auth service
    AuthService myAuthService = AuthService.firebase();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sing-up',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: myAuthService.initialize(),
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
                      final password1 = _password.text;
                      final password2 = _password2.text;
                      try {
                        await myAuthService.createUser(
                          email: email,
                          password1: password1,
                          password2: password2,
                        );
                        //Send email verification
                        await myAuthService.sendEmailVerification();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          myRoutes.verifyEmail,
                          (route) => false,
                        );
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
        },
      ),
    );
  }
}
