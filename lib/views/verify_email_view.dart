import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

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
  late AuthService myAuthService;
  late AuthBloc myAuthBloc;
  @override
  void initState() {
    /*** FB Service ***/
    myAuthService = AuthService.firebase();
    enabled = false;
    setEnabledTimer();
    super.initState();
  }

  @override
  void dispose() {
    verifiedEmailTimer;
    changeEnableTimer;
    enabled;
    super.dispose();
  }

  setEnabledTimer() {
    changeEnableTimer = Timer(const Duration(seconds: 30), () {
      setState(() {
        enabled = true;
        changeEnableTimer.cancel();
      });
    });
  }

  sendEmailFunction() {
    if (enabled) {
      return () async {
        setEnabledTimer();
        setState(() {
          enabled = false;
        });
        await myAuthService.sendEmailVerification();
      };
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    myAuthBloc = AuthBloc(myAuthService);
    verifiedEmailTimer =
        Timer.periodic(const Duration(seconds: 3), (verifiedEmailTimer) async {
      myAuthBloc.add(AuthEventCheckEmailVerified());
    });
    return BlocProvider(
      create: (context) => myAuthBloc,
      lazy: false,
      child: Scaffold(
          backgroundColor: Colors.amber,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Verify email'),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              log('Recieving the state');
              if (state is AuthStateLoggedIn) {
                await Navigator.pushNamedAndRemoveUntil(
                    context, MyRoutes.notesView, (route) => false);
              }
            },
            child: Center(
              child: Column(
                children: [
                  const Text(
                      'We\'ve sent you a verification email, please verify'),
                  Text(
                      'Please, check your email: ${myAuthService.currentUser?.userEmail ?? ''}'),
                  ElevatedButton(
                    onPressed: sendEmailFunction(),
                    child: const Text('Re-send email verification!'),
                  ),
                  TextButton(
                      onPressed: () async {
                        verifiedEmailTimer.cancel();
                        await Navigator.pushNamedAndRemoveUntil(
                            context, MyRoutes.loginView, (route) => false);
                      },
                      child: const Text('go back to log-in')),
                ],
              ),
            ),
          )),
    );
  }
}
