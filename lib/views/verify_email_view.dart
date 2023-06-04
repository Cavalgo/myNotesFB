import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emial not verfied!'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Please, verify your email address'),
            TextButton(
              onPressed: () async {
                final User? currentUser = FirebaseAuth.instance.currentUser;
                await currentUser?.sendEmailVerification();
              },
              child: const Text('Send email verification!'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, myRoutes.loginView, (route) => false);
                },
                child: const Text('go back to log-in')),
          ],
        ),
      ),
    );
  }
}
