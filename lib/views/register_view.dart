import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;
  late AuthBloc myAuthBloc;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sing-up',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
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
            decoration: const InputDecoration(hintText: 'Enter password'),
            obscureText: true,
          ),
          TextField(
            controller: _password2,
            decoration: const InputDecoration(hintText: 'Confirm password'),
            obscureText: true,
          ),
          TextButton(
            onPressed: () {
              final email = _email.text;
              final password = _password.text;
              final password2 = _password2.text;
              context.read<AuthBloc>().add(AuthEventRegister(
                    email: email,
                    password: password,
                    password2: password2,
                  ));
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () => {
                    BlocProvider.of<AuthBloc>(context).add(
                      const AuthEventGoToLogIn(),
                    )
                  },
              child: const Text('Go back to log-in')),
        ],
      ),
    );
  }
}
