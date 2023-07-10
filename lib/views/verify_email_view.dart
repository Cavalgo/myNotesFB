import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    enabled = false;
    setEnabledTimer();
    super.initState();
  }

  @override
  void dispose() {
    verifiedEmailTimer.cancel();
    changeEnableTimer.cancel();
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

  deactivateResendButton(BuildContext context) {
    if (enabled) {
      BlocProvider.of<AuthBloc>(context)
          .add(const AuthEventResendEmailVerification());
      return () {
        setEnabledTimer();
        setState(() {
          enabled = false;
        });
      };
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    verifiedEmailTimer =
        Timer.periodic(const Duration(seconds: 3), (verifiedEmailTimer) async {
      BlocProvider.of<AuthBloc>(context)
          .add(const AuthEventCheckEmailVerified());
    });
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Verify email'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateLoggedIn) {
            verifiedEmailTimer.cancel();
          }
        },
        child: Center(
          child: Column(
            children: [
              const Text('We\'ve sent you a verification email, please verify'),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthStateNeedsVerification) {
                    return Text('Please, check your email: ${state.email}');
                  } else {
                    return const Text('Please, check your email: ');
                  }
                },
              ),
              ElevatedButton(
                onPressed: deactivateResendButton(context),
                child: const Text('Re-send email verification!'),
              ),
              TextButton(
                  onPressed: () async {
                    verifiedEmailTimer.cancel();
                    BlocProvider.of<AuthBloc>(context)
                        .add(const AuthEventGoToLogIn());
                  },
                  child: const Text('go back to log-in')),
            ],
          ),
        ),
      ),
    );
  }
}
