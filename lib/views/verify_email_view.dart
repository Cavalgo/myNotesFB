import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

//Timer:
//https://www.flutterbeads.com/flutter-countdown-timer/#:~:text=Steps%20to%20add%20countdown%20timer,()%20to%20stop%20the%20timer.
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late Timer verifiedEmailTimer;
  late Timer changeEnableTimer;
  late bool enabled;
  @override
  void initState() {
    enabled = false;
    // TODO: implement initState
    verifiedEmailTimer =
        Timer.periodic(const Duration(seconds: 3), (verifiedEmailTimer) {
      FirebaseAuth.instance.currentUser?.reload();
      User? cUser = FirebaseAuth.instance.currentUser;
      if (cUser?.emailVerified ?? false) {
        verifiedEmailTimer.cancel();
        Navigator.pushNamedAndRemoveUntil(
            context, myRoutes.notesView, (route) => false);
      }
    });
    setEnabledTimer();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    verifiedEmailTimer;
    changeEnableTimer;
    enabled;
    super.dispose();
  }

  setEnabledTimer() {
    //Timer 2
    changeEnableTimer = Timer(const Duration(seconds: 30), () {
      setState(() {
        enabled = true;
        changeEnableTimer.cancel();
      });
    });
  }

  sendEmailFunction() {
    print('object');
    if (enabled) {
      log('Retunrn fuction');
      return () {
        log('you cclikeccd');
        setEnabledTimer();
        setState(() {
          enabled = false;
        });
        log('email should be sent');
        //await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      };
    } else {
      log('I didt Retunrn fuction');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Verify email'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('We\'ve sent you a verification email, please verify'),
            Text(
                'Please, check your email: ${FirebaseAuth.instance.currentUser?.email}'),
            ElevatedButton(
              onPressed: sendEmailFunction(),
              child: const Text('Re-send email verification!'),
            ),
            TextButton(
                onPressed: () async {
                  verifiedEmailTimer.cancel();
                  await Navigator.pushNamedAndRemoveUntil(
                      context, myRoutes.loginView, (route) => false);
                },
                child: const Text('go back to log-in')),
          ],
        ),
      ),
    );
  }
}
