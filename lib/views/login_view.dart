import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

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
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
/*####################.  LISTENER LOGIN EXCEPTIONS    ######################*/
              if (state is AuthStateLoggedOut && state.exception != null) {
                if (state.exception is MyExceptions) {
                  MyExceptions myE = state.exception as MyExceptions;
                  await showErrorDialog(
                    context,
                    myE.reason,
                    myE.description,
                  );
                } else {
                  await showErrorDialog(
                    context,
                    GenericAuthException().reason,
                    state.exception.toString(),
                  );
                }
              }
            },
            child: TextButton(
              onPressed: () {
                final String email = _email.text;
                final String password = _password.text;
/***################    LOG-IN EVENT     ##################***/
                BlocProvider.of<AuthBloc>(context).add(AuthEventLogIn(
                  email: email,
                  password: password,
                ));
              },
              child: const Text('Log-in'),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                MyRoutes.registerView,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}

/**
 * 
 * 
 BlocListener<AuthBloc, AuthState>(
  /*#################### LISTENER TO HANDLE LOGIN EXCEPTIONS ######################*/
      listener: (context, state) {
        if (state is AuthStateLoggedOut && state.exception != null) {
          if (state.exception is MyExceptions) {
            MyExceptions myE = state.exception as MyExceptions;
            showErrorDialog(
              context,
              myE.reason,
              myE.description,
            );
          } else {
            showErrorDialog(
              context,
              GenericAuthException().reason,
              state.exception.toString(),
            );
          }
        }
      }, 
 */